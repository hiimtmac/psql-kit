// JoinTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
import PSQLKit

@Suite
struct JoinTests {
    let p = PSQLModel.as("x")

    @Test
    func testJoinModel() {
        var serializer = SQLSerializer.test

        JOIN(PSQLModel.table) {
            PSQLModel.$name == PSQLModel.$name
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" ON ("my_model"."name" = "my_model"."name")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testJoinModelAlias() {
        var serializer = SQLSerializer.test

        JOIN(self.p.table) {
            p.$name == p.$name
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = "x"."name")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testJoinBoth() {
        var serializer = SQLSerializer.test

        JOIN(self.p.table, method: .left) {
            p.$name == PSQLModel.$name
            PSQLModel.$name == p.$name
        }
        .serialize(to: &serializer)

        let compare = #"LEFT JOIN "my_model" AS "x" ON ("x"."name" = "my_model"."name") AND ("my_model"."name" = "x"."name")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testJoinN() {
        var serializer = SQLSerializer.test

        JOIN(self.p.table) {
            p.$name == p.$name
            p.$name == PSQLModel.$name || p.$name != p.$name
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = "x"."name") AND (("x"."name" = "my_model"."name") OR ("x"."name" != "x"."name"))"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testJoinRaw() {
        var serializer = SQLSerializer.test

        JOIN(RawTable("cool")) {
            p.$name == p.$name
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "cool" ON ("x"."name" = "x"."name")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test

        let bool = true

        JOIN(self.p.table) {
            if bool {
                p.$name == "tmac"
            } else {
                p.$age == 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = 'tmac')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test

        let bool = false

        JOIN(self.p.table) {
            if bool {
                p.$name == "tmac"
            } else {
                p.$age == 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29)"#
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

        JOIN(self.p.table) {
            switch option {
            case .one: p.$name == "tmac"
            case .two: p.$age == 29
            case .three:
                p.$age == 29
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfTrue() {
        var serializer = SQLSerializer.test

        let bool = true

        JOIN(self.p.table) {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29) AND ("x"."name" = 'tmac')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfFalse() {
        var serializer = SQLSerializer.test

        let bool = false

        JOIN(self.p.table) {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test

        JOIN(self.p.table) {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
