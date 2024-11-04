// QueryTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class QueryTests: PSQLTestCase {
    let f = FluentModel.as("x")

    func testQuery() {
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"SELECT "x"."name"::TEXT FROM "my_model" AS "x""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testQueryAsSub() {
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .asSubquery(FluentModel.table)
        .serialize(to: &fluentSerializer)

        let compare = #"(SELECT "x"."name"::TEXT FROM "my_model" AS "x") AS "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testQueryAsWith() {
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .asWith(self.f.table)
        .serialize(to: &fluentSerializer)

        let compare = #""x" AS (SELECT "x"."name"::TEXT FROM "my_model" AS "x")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
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

        let compare = #"SELECT "x"."name"::TEXT, "x"."title"::TEXT FROM "my_model" AS "x" GROUP BY "x"."name" ORDER BY "x"."name" DESC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
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

        let compare = #"SELECT "x"."name"::TEXT UNION SELECT "x"."name"::TEXT UNION SELECT "x"."name"::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
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

        let compare = #"SELECT "x"."name"::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
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

        let compare = #"SELECT "x"."age"::INTEGER"#
        XCTAssertEqual(fluentSerializer.sql, compare)
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

        let compare = #"SELECT "x"."age"::INTEGER"#
        XCTAssertEqual(fluentSerializer.sql, compare)
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

        let compare = #"SELECT (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testReturning() {
        QUERY {
            UPDATE(f.table) {
                f.$name => "taylor"
            }
            WHERE { f.$name == "tmac" }
            RETURNING { f.$id }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'taylor' WHERE ("x"."name" = 'tmac') RETURNING "x"."id"::UUID"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testEmpty() {
        QUERY {}
            .serialize(to: &fluentSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
