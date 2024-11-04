// QueryTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class QueryTests: PSQLTestCase {
    let p = PSQLModel.as("x")

    func testQuery() {
        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."name"::TEXT FROM "my_model" AS "x""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testQueryAsSub() {
        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .asSubquery(PSQLModel.table)
        .serialize(to: &serializer)

        let compare = #"(SELECT "x"."name"::TEXT FROM "my_model" AS "x") AS "my_model""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testQueryAsWith() {
        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .asWith(self.p.table)
        .serialize(to: &serializer)

        let compare = #""x" AS (SELECT "x"."name"::TEXT FROM "my_model" AS "x")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testQueryN() {
        QUERY {
            SELECT {
                p.$name
                p.$title
            }
            FROM { p.table }
            GROUPBY { p.$name }
            ORDERBY { p.$name.desc() }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."name"::TEXT, "x"."title"::TEXT FROM "my_model" AS "x" GROUP BY "x"."name" ORDER BY "x"."name" DESC"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testUnion() {
        QUERY {
            UNION {
                QUERY { SELECT { p.$name } }
                QUERY { SELECT { p.$name } }
                QUERY { SELECT { p.$name } }
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."name"::TEXT UNION SELECT "x"."name"::TEXT UNION SELECT "x"."name"::TEXT"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        
        QUERY {
            if bool {
                SELECT { p.$name }
            } else {
                SELECT { p.$age }
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."name"::TEXT"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false

        QUERY {
            if bool {
                SELECT { p.$name }
            } else {
                SELECT { p.$age }
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."age"::INTEGER"#
        XCTAssertEqual(serializer.sql, compare)
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
            case .one: SELECT { p.$name }
            case .two: SELECT { p.$age }
            case .three:
                SELECT { p.$name }
                FROM { p.table }
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."age"::INTEGER"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testSelectSubquery() {
        SELECT {
            QUERY {
                SELECT { p.$age }
                FROM { p.table }
            }
            .asSubquery(p.table)
        }
        .serialize(to: &serializer)

        let compare = #"SELECT (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testReturning() {
        QUERY {
            UPDATE(p.table) {
                p.$name => "taylor"
            }
            WHERE { p.$name == "tmac" }
            RETURNING { p.$id }
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'taylor' WHERE ("x"."name" = 'tmac') RETURNING "x"."id"::UUID"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testEmpty() {
        QUERY {}
            .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
