// AdvancedTests.swift
// Copyright (c) 2024 hiimtmac inc.

import FluentKit
import FluentPSQLKit
import Foundation
import SQLKit
import Testing

@Suite
struct AdvancedTests {
    @FluentCTE("pet")
    final class Pet: Model, @unchecked Sendable {
        @ID
        var id: UUID?
        @Field(key: "name")
        var name: String
        @Parent(key: "owner_id")
        var owner: Owner

        init() {}
    }

    @FluentCTE("owner")
    final class Owner: Model, @unchecked Sendable {
        @ID
        var id: UUID?
        @Field(key: "name")
        var name: String
        @Field(key: "age")
        var age: Int
        @Field(key: "bday")
        var bday: PSQLDate

        init() {}
    }

    @FluentCTE("schema", schemaName: "space")
    final class ModelSpace: Model, @unchecked Sendable {
        @ID
        var id: UUID?
        @Field(key: "name")
        var name: String

        init() {}
    }

    @CTE("schema", schemaName: "space")
    struct TableSpace {
        var name: String
    }

    @CTE("date_range")
    struct DateRange {
        var date: PSQLDate
    }

    @CTE("owner_filter")
    struct OwnerFilter {
        var id: UUID
    }

    @CTE("owner_date_series")
    struct OwnerDateSeries {
        var id: UUID?
        var date: PSQLDate
    }

    @Test
    func testSpaces() {
        var serializer = SQLSerializer.test
        QUERY {
            SELECT { ModelSpace.$name }
            FROM { ModelSpace.table }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "space"."schema"."name"::TEXT FROM "space"."schema""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSpacesAlias() {
        var serializer = SQLSerializer.test
        let f = ModelSpace.as("a")

        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "a"."name"::TEXT FROM "space"."schema" AS "a""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testTypesCompile() {
        _ = WHERE {
            // Custom UUID vs Custom UUID?
            OwnerFilter.$id == OwnerDateSeries.$id
            // Fluent UUID? vs Custom UUID?
            Owner.$id == OwnerDateSeries.$id
            // Fluent UUID? vs Custom UUID
            Owner.$id == OwnerFilter.$id
        }
    }

    @Test
    func testExample() {
        var serializer = SQLSerializer.test
        let d1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 31).date!
        let d2 = DateComponents(calendar: .current, year: 2020, month: 07, day: 31).date!
        let r = DateRange.as("r")
        let dateCol = RawColumn<PSQLDate>("date")
        let p = Pet.as("p")
        let o = Owner.as("o")
        let f = OwnerFilter.as("f")

        let query = QUERY {
            WITH {
                QUERY {
                    SELECT { dateCol }
                    FROM { GENERATE_SERIES(from: PSQLBind(d1.psqlDate), to: d2.psqlDate.asBind(), interval: "1 day") }
                    ORDERBY { dateCol }
                }
                .asWith(r.table) // access the results from this query using r.$...
                QUERY {
                    SELECT { o.$id }.distinct()
                    FROM { p.table }
                    JOIN(o.table) { o.$id == p.$owner }
                    WHERE {
                        o.$age > 20
                        p.$name == "dog"
                    }
                }
                .asWith(f.table) // access the results from this query using f.$...
                QUERY {
                    SELECT {
                        r.$date
                        f.$id
                    }
                    FROM { f.table }
                    JOIN(r.table) { true }
                }
                .asWith(OwnerDateSeries.table) // not using alias to access results with full type...
            }

            SELECT {
                OwnerDateSeries.$date
                o.$name
            }
            FROM { f.table }
            JOIN(o.table, method: .left) { f.$id == o.$id }
            JOIN(OwnerDateSeries.table) { o.$bday == OwnerDateSeries.$date }
        }
        query.serialize(to: &serializer)

        let sub1 = [
            #"SELECT "date"::DATE"#,
            #"FROM GENERATE_SERIES($1, $2, '1 day'::INTERVAL)"#,
            #"ORDER BY "date""#,
        ].joined(separator: " ")

        let sub2 = [
            #"SELECT DISTINCT "o"."id"::UUID FROM "pet" AS "p""#,
            #"INNER JOIN "owner" AS "o" ON ("o"."id" = "p"."owner_id")"#,
            #"WHERE ("o"."age" > 20) AND ("p"."name" = 'dog')"#,
        ].joined(separator: " ")

        let sub3 = [
            #"SELECT "r"."date"::DATE, "f"."id"::UUID"#,
            #"FROM "owner_filter" AS "f""#,
            #"INNER JOIN "date_range" AS "r" ON true"#,
        ].joined(separator: " ")

        let compare = [
            "WITH",
            #""r" AS (\#(sub1)),"#,
            #""f" AS (\#(sub2)),"#,
            #""owner_date_series" AS (\#(sub3))"#,
            #"SELECT "owner_date_series"."date"::DATE, "o"."name"::TEXT"#,
            #"FROM "owner_filter" AS "f""#,
            #"LEFT JOIN "owner" AS "o" ON ("f"."id" = "o"."id")"#,
            #"INNER JOIN "owner_date_series" ON ("o"."bday" = "owner_date_series"."date")"#,
        ].joined(separator: " ")

        #expect(serializer.sql == compare)
        print(serializer.sql)
    }
}
