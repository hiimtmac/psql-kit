// AdvancedTests.swift
// Copyright © 2022 hiimtmac

import FluentKit
import PSQLKit
import XCTest

final class AdvancedTests: PSQLTestCase {
    final class Pet: Model, Table {
        static let schema = "pet"

        @ID
        var id: UUID?
        @Field(key: "name")
        var name: String
        @Parent(key: "owner_id")
        var owner: Owner

        init() {}
    }

    final class Owner: Model, Table {
        static let schema = "owner"

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

    struct DateRange: Table {
        static let schema: String = "date_range"
        @Column(key: "date")
        var date: PSQLDate
    }

    struct OwnerFilter: Table {
        @Column(key: "id")
        var id: UUID
    }

    struct OwnerDateSeries: Table {
        @OptionalColumn(key: "id")
        var id: UUID?
        @Column(key: "date")
        var date: PSQLDate
    }

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

    func testExample() {
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
        query.serialize(to: &fluentSerializer)

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
            #"FROM "OwnerFilter" AS "f""#,
            #"INNER JOIN "date_range" AS "r" ON true"#,
        ].joined(separator: " ")

        let compare = [
            "WITH",
            #""r" AS (\#(sub1)),"#,
            #""f" AS (\#(sub2)),"#,
            #""OwnerDateSeries" AS (\#(sub3))"#,
            #"SELECT "OwnerDateSeries"."date"::DATE, "o"."name"::TEXT"#,
            #"FROM "OwnerFilter" AS "f""#,
            #"LEFT JOIN "owner" AS "o" ON ("f"."id" = "o"."id")"#,
            #"INNER JOIN "OwnerDateSeries" ON ("o"."bday" = "OwnerDateSeries"."date")"#,
        ].joined(separator: " ")

        XCTAssertEqual(fluentSerializer.sql, compare)
        print(fluentSerializer.sql)
    }
}
