// WithTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class WithTests: PSQLTestCase {
    let p = PSQLModel.as("x")

    func testWith1() {
        WITH {
            QUERY {
                SELECT { PSQLModel.$name }
                FROM { PSQLModel.table }
            }
            .asWith(PSQLModel.table)
        }
        .serialize(to: &serializer)

        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testWith2() {
        WITH {
            QUERY {
                SELECT { p.$title }
                FROM { p.table }
            }
            .asWith(p.table)
        }
        .serialize(to: &serializer)

        let compare = #"WITH "x" AS (SELECT "x"."title"::TEXT FROM "my_model" AS "x")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testWithInQuery() {
        QUERY {
            WITH {
                QUERY {
                    SELECT { PSQLModel.$name }
                    FROM { PSQLModel.table }
                }
                .asWith(PSQLModel.table)
            }
            SELECT { PSQLModel.$name }
            FROM { PSQLModel.table }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model") SELECT "my_model"."name"::TEXT FROM "my_model""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testWithErased() {
        let p = QUERY {
            SELECT { PSQLModel.$name }
            FROM { PSQLModel.table }
        }

        QUERY {
            WITH { p.asWith(PSQLModel.table) }
            SELECT { PSQLModel.$name }
            FROM { PSQLModel.table }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model") SELECT "my_model"."name"::TEXT FROM "my_model""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true

        WITH {
            if bool {
                QUERY { SELECT { p.$title } }.asWith(p.table)
            } else {
                QUERY { SELECT { p.$age } }.asWith(p.table)
            }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "x" AS (SELECT "x"."title"::TEXT)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false

        WITH {
            if bool {
                QUERY { SELECT { p.$title } }.asWith(p.table)
            } else {
                QUERY { SELECT { p.$age } }.asWith(p.table)
            }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "x" AS (SELECT "x"."age"::INTEGER)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testSwitch() {
        enum Test {
            case one
            case two
            case three
        }

        let option = Test.two

        WITH {
            switch option {
            case .one: QUERY { SELECT { p.$title } }.asWith(p.table)
            case .two: QUERY { SELECT { p.$age } }.asWith(p.table)
            case .three:
                QUERY { SELECT { p.$title } }.asWith(p.table)
                QUERY { SELECT { p.$age } }.asWith(p.table)
            }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "x" AS (SELECT "x"."age"::INTEGER)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true

        WITH {
            if bool {
                QUERY { SELECT { p.$title } }.asWith(p.table)
            }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "x" AS (SELECT "x"."title"::TEXT)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false

        WITH {
            if bool {
                QUERY { SELECT { p.$title } }.asWith(p.table)
            }
        }
        .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testEmpty() {
        WITH {}
            .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
