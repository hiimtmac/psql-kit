// HavingTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
import PSQLKit

@Suite
struct HavingTests {
    let p = PSQLModel.as("x")

    @Test
    func testHaving1() {
        var serializer = SQLSerializer.test

        HAVING {
            PSQLModel.$name == PSQLModel.$title
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("my_model"."name" = "my_model"."title")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testHaving2() {
        var serializer = SQLSerializer.test

        HAVING {
            p.$name != p.$name
        }
        .serialize(to: &serializer)

        let compare = #"HAVING ("x"."name" != "x"."name")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testHavingN() {
        var serializer = SQLSerializer.test

        HAVING {
            PSQLModel.$name == p.$name
            p.$name == PSQLModel.$name
            p.$name != p.$name || PSQLModel.$name != PSQLModel.$name
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
                p.$name == "tmac"
            } else {
                p.$age == 29
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
                p.$name == "tmac"
            } else {
                p.$age == 29
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
            case .one: p.$name == "tmac"
            case .two: p.$age == 29
            case .three:
                p.$age == 29
                p.$name == "tmac"
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
                p.$name == "tmac"
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
            p.$age == 29
            if bool {
                p.$name == "tmac"
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
