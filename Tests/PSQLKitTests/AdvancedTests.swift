// AdvancedTests.swift
// Copyright (c) 2024 hiimtmac inc.

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
    
    final class ModelSpace: Model, Table {
        static let schema = "schema"
        static let space: String? = "space"

        @ID
        var id: UUID?
        @Field(key: "name")
        var name: String

        init() {}
    }
    
    struct TableSpace: Table {
        static let schema: String = "schema"
        static let path: String? = "space"
        @Column(key: "name")
        var name: String
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
    
    func testSpaces() {
        QUERY {
            SELECT { TableSpace.$name }
            FROM { TableSpace.table }
        }
        .serialize(to: &psqlkitSerializer)
        
        QUERY {
            SELECT { ModelSpace.$name }
            FROM { ModelSpace.table }
        }
        .serialize(to: &fluentSerializer)
        
        let compare = #"SELECT "space"."schema"."name"::TEXT FROM "space"."schema""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSpacesAlias() {
        let p = TableSpace.as("a")
        let f = ModelSpace.as("a")
        
        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .serialize(to: &psqlkitSerializer)
        
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .serialize(to: &fluentSerializer)
        
        let compare = #"SELECT "a"."name"::TEXT FROM "space"."schema" AS "a""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
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
