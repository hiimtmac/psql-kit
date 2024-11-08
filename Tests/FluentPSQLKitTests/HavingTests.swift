// HavingTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct HavingTests {
    let f = FluentModel.as("x")

    @Test
    func testHaving1() {
        var serializer = SQLSerializer.test
        HAVING {
            FluentModel.$name == FluentModel.$title
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("my_model"."name" = "my_model"."title")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testHaving2() {
        var serializer = SQLSerializer.test
        HAVING {
            f.$name != f.$name
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."name" != "x"."name")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testHavingN() {
        var serializer = SQLSerializer.test
        HAVING {
            FluentModel.$name == f.$name
            f.$name == FluentModel.$name
            f.$name != f.$name || FluentModel.$name != FluentModel.$name
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("my_model"."name" = "x"."name") AND ("x"."name" = "my_model"."name") AND (("x"."name" != "x"."name") OR ("my_model"."name" != "my_model"."name"))"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test
        let bool = true
        HAVING {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."name" = 'tmac')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test
        let bool = false
        HAVING {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."age" = 29)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSwitch() {
        var serializer = SQLSerializer.test
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
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."age" = 29)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfTrue() {
        var serializer = SQLSerializer.test
        let bool = true
        HAVING {
            if bool {
                f.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."name" = 'tmac')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfFalse() {
        var serializer = SQLSerializer.test
        let bool = false
        HAVING {
            f.$age == 29
            if bool {
                f.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."age" = 29)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test
        HAVING {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
