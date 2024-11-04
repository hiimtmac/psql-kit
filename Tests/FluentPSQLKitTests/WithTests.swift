// WithTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class WithTests: PSQLTestCase {
    let f = FluentModel.as("x")

    func testWith1() {
        WITH {
            QUERY {
                SELECT { FluentModel.$name }
                FROM { FluentModel.table }
            }
            .asWith(FluentModel.table)
        }
        .serialize(to: &fluentSerializer)

        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testWith2() {
        WITH {
            QUERY {
                SELECT { f.$title }
                FROM { f.table }
            }
            .asWith(f.table)
        }
        .serialize(to: &fluentSerializer)

        let compare = #"WITH "x" AS (SELECT "x"."title"::TEXT FROM "my_model" AS "x")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testWithInQuery() {
        QUERY {
            WITH {
                QUERY {
                    SELECT { FluentModel.$name }
                    FROM { FluentModel.table }
                }
                .asWith(FluentModel.table)
            }
            SELECT { FluentModel.$name }
            FROM { FluentModel.table }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model") SELECT "my_model"."name"::TEXT FROM "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testWithErased() {
        let f = QUERY {
            SELECT { FluentModel.$name }
            FROM { FluentModel.table }
        }

        QUERY {
            WITH { f.asWith(FluentModel.table) }
            SELECT { FluentModel.$name }
            FROM { FluentModel.table }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model") SELECT "my_model"."name"::TEXT FROM "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        WITH {
            if bool {
                QUERY { SELECT { f.$title } }.asWith(f.table)
            } else {
                QUERY { SELECT { f.$age } }.asWith(f.table)
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"WITH "x" AS (SELECT "x"."title"::TEXT)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        WITH {
            if bool {
                QUERY { SELECT { f.$title } }.asWith(f.table)
            } else {
                QUERY { SELECT { f.$age } }.asWith(f.table)
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"WITH "x" AS (SELECT "x"."age"::INTEGER)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
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
            case .one: QUERY { SELECT { f.$title } }.asWith(f.table)
            case .two: QUERY { SELECT { f.$age } }.asWith(f.table)
            case .three:
                QUERY { SELECT { f.$title } }.asWith(f.table)
                QUERY { SELECT { f.$age } }.asWith(f.table)
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"WITH "x" AS (SELECT "x"."age"::INTEGER)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true
        WITH {
            if bool {
                QUERY { SELECT { f.$title } }.asWith(f.table)
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"WITH "x" AS (SELECT "x"."title"::TEXT)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false
        WITH {
            if bool {
                QUERY { SELECT { f.$title } }.asWith(f.table)
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testEmpty() {
        WITH {}
            .serialize(to: &fluentSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
