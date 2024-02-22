// QueryTests.swift
// Copyright © 2022 hiimtmac

import FluentKit
import XCTest
@testable import PSQLKit

final class QueryTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")

    func testQuery() {
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT "x"."name"::TEXT FROM "my_model" AS "x""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testQueryAsSub() {
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .asSubquery(FluentModel.table)
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .asSubquery(PSQLModel.table)
        .serialize(to: &psqlkitSerializer)

        let compare = #"(SELECT "x"."name"::TEXT FROM "my_model" AS "x") AS "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testQueryAsWith() {
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .asWith(self.f.table)
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .asWith(self.p.table)
        .serialize(to: &psqlkitSerializer)

        let compare = #""x" AS (SELECT "x"."name"::TEXT FROM "my_model" AS "x")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testQueryN() {
        QUERY {
            SELECT {
                f.$name
                f.$title
            }
            FROM { f.table }
            GROUPBY { f.$name }
            ORDERBY { f.$name.desc() }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT {
                p.$name
                p.$title
            }
            FROM { p.table }
            GROUPBY { p.$name }
            ORDERBY { p.$name.desc() }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT "x"."name"::TEXT, "x"."title"::TEXT FROM "my_model" AS "x" GROUP BY "x"."name" ORDER BY "x"."name" DESC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testUnion() {
        QUERY {
            UNION {
                QUERY { SELECT { f.$name } }
                QUERY { SELECT { f.$name } }
                QUERY { SELECT { f.$name } }
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            UNION {
                QUERY { SELECT { p.$name } }
                QUERY { SELECT { p.$name } }
                QUERY { SELECT { p.$name } }
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT "x"."name"::TEXT UNION SELECT "x"."name"::TEXT UNION SELECT "x"."name"::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        QUERY {
            if bool {
                SELECT { f.$name }
            } else {
                SELECT { f.$age }
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            if bool {
                SELECT { p.$name }
            } else {
                SELECT { p.$age }
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT "x"."name"::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        QUERY {
            if bool {
                SELECT { f.$name }
            } else {
                SELECT { f.$age }
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            if bool {
                SELECT { p.$name }
            } else {
                SELECT { p.$age }
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT "x"."age"::INTEGER"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testSwitch() {
        enum Test {
            case one
            case two
            case three
        }

        let option = Test.two

        QUERY {
            switch option {
            case .one: SELECT { f.$name }
            case .two: SELECT { f.$age }
            case .three:
                SELECT { f.$name }
                FROM { f.table }
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            switch option {
            case .one: SELECT { p.$name }
            case .two: SELECT { p.$age }
            case .three:
                SELECT { p.$name }
                FROM { p.table }
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT "x"."age"::INTEGER"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSelectSubquery() {
        SELECT {
            QUERY {
                SELECT { f.$age }
                FROM { f.table }
            }
            .asSubquery(f.table)
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            QUERY {
                SELECT { p.$age }
                FROM { p.table }
            }
            .asSubquery(p.table)
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

//    func testReturning() {
//        QUERY {
//            UPDATE(f.table) {
//                f.$name => "taylor"
//            }
//            WHERE { f.$name == "tmac" }
//            RETURNING { f.$id }
//        }
//        .serialize(to: &fluentSerializer)
//
//        QUERY {
//            UPDATE(p.table) {
//                p.$name => "taylor"
//            }
//            WHERE { p.$name == "tmac" }
//            RETURNING { p.$id }
//        }
//        .serialize(to: &psqlkitSerializer)
//
//        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'taylor' WHERE ("x"."name" = 'tmac') RETURNING "x"."id"::UUID"#
//        XCTAssertEqual(fluentSerializer.sql, compare)
//        XCTAssertEqual(psqlkitSerializer.sql, compare)
//    }
}
