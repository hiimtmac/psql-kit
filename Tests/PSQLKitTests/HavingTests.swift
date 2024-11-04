// HavingTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class HavingTests: PSQLTestCase {
    let p = PSQLModel.as("x")

    func testHaving1() {
        HAVING {
            PSQLModel.$name == PSQLModel.$title
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("my_model"."name" = "my_model"."title")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testHaving2() {
        HAVING {
            p.$name != p.$name
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."name" != "x"."name")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testHavingN() {
        HAVING {
            PSQLModel.$name == p.$name
            p.$name == PSQLModel.$name
            p.$name != p.$name || PSQLModel.$name != PSQLModel.$name
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("my_model"."name" = "x"."name") AND ("x"."name" = "my_model"."name") AND (("x"."name" != "x"."name") OR ("my_model"."name" != "my_model"."name"))"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true

        HAVING {
            if bool {
                p.$name == "tmac"
            } else {
                p.$age == 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."name" = 'tmac')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false

        HAVING {
            if bool {
                p.$name == "tmac"
            } else {
                p.$age == 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."age" = 29)"#
        XCTAssertEqual(serializer.sql, compare)
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
            case .one: p.$name == "tmac"
            case .two: p.$age == 29
            case .three:
                p.$age == 29
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."age" = 29)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true

        HAVING {
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."name" = 'tmac')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false

        HAVING {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."age" = 29)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testEmpty() {
        HAVING {}
            .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
