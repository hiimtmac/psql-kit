// JoinTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct JoinTests {
    let f = FluentModel.as("x")

    @Test
    func testJoinModel() {
        var serializer = SQLSerializer.test
        JOIN(FluentModel.table) {
            FluentModel.$name == FluentModel.$name
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" ON ("my_model"."name" = "my_model"."name")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testJoinModelAlias() {
        var serializer = SQLSerializer.test
        JOIN(self.f.table) {
            f.$name == f.$name
        }

        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = "x"."name")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testJoinBoth() {
        var serializer = SQLSerializer.test
        JOIN(self.f.table, method: .left) {
            f.$name == FluentModel.$name
            FluentModel.$name == f.$name
        }
        .serialize(to: &serializer)

        let compare = #"LEFT JOIN "my_model" AS "x" ON ("x"."name" = "my_model"."name") AND ("my_model"."name" = "x"."name")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testJoinN() {
        var serializer = SQLSerializer.test
        JOIN(self.f.table) {
            f.$name == f.$name
            f.$name == FluentModel.$name || f.$name != f.$name
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = "x"."name") AND (("x"."name" = "my_model"."name") OR ("x"."name" != "x"."name"))"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testJoinRaw() {
        var serializer = SQLSerializer.test
        JOIN(RawTable("cool")) {
            f.$name == f.$name
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "cool" ON ("x"."name" = "x"."name")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test
        let bool = true
        JOIN(self.f.table) {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
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
        JOIN(self.f.table) {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
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

        JOIN(self.f.table) {
            switch option {
            case .one: f.$name == "tmac"
            case .two: f.$age == 29
            case .three:
                f.$age == 29
                f.$name == "tmac"
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
        JOIN(self.f.table) {
            f.$age == 29
            if bool {
                f.$name == "tmac"
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
        JOIN(self.f.table) {
            f.$age == 29
            if bool {
                f.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test
        JOIN(self.f.table) {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
