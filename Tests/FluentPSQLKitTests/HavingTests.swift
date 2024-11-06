// HavingTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import FluentPSQLKit

final class HavingTests: PSQLTestCase {
    let f = FluentModel.as("x")

    func testHaving1() {
        HAVING {
            FluentModel.$name == FluentModel.$title
        }
        .serialize(to: &fluentSerializer)

        let compare = #"HAVING ("my_model"."name" = "my_model"."title")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testHaving2() {
        HAVING {
            f.$name != f.$name
        }
        .serialize(to: &fluentSerializer)

        let compare = #"HAVING ("x"."name" != "x"."name")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testHavingN() {
        HAVING {
            FluentModel.$name == f.$name
            f.$name == FluentModel.$name
            f.$name != f.$name || FluentModel.$name != FluentModel.$name
        }
        .serialize(to: &fluentSerializer)

        let compare = #"HAVING ("my_model"."name" = "x"."name") AND ("x"."name" = "my_model"."name") AND (("x"."name" != "x"."name") OR ("my_model"."name" != "my_model"."name"))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        HAVING {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"HAVING ("x"."name" = 'tmac')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        HAVING {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"HAVING ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testSwitch() {
        enum Test {
            case one
            case two
            case three
        }

        let option = Test.two

        HAVING {
            switch option {
            case .one: f.$name == "tmac"
            case .two: f.$age == 29
            case .three:
                f.$age == 29
                f.$name == "tmac"
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"HAVING ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true
        HAVING {
            if bool {
                f.$name == "tmac"
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"HAVING ("x"."name" = 'tmac')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false
        HAVING {
            f.$age == 29
            if bool {
                f.$name == "tmac"
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"HAVING ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testEmpty() {
        HAVING {}
            .serialize(to: &fluentSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
