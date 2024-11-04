// JoinTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class JoinTests: PSQLTestCase {
    let f = FluentModel.as("x")

    func testJoinModel() {
        JOIN(FluentModel.table) {
            FluentModel.$name == FluentModel.$name
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INNER JOIN "my_model" ON ("my_model"."name" = "my_model"."name")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testJoinModelAlias() {
        JOIN(self.f.table) {
            f.$name == f.$name
        }

        .serialize(to: &fluentSerializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = "x"."name")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testJoinBoth() {
        JOIN(self.f.table, method: .left) {
            f.$name == FluentModel.$name
            FluentModel.$name == f.$name
        }
        .serialize(to: &fluentSerializer)

        let compare = #"LEFT JOIN "my_model" AS "x" ON ("x"."name" = "my_model"."name") AND ("my_model"."name" = "x"."name")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testJoinN() {
        JOIN(self.f.table) {
            f.$name == f.$name
            f.$name == FluentModel.$name || f.$name != f.$name
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = "x"."name") AND (("x"."name" = "my_model"."name") OR ("x"."name" != "x"."name"))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testJoinRaw() {
        JOIN(RawTable("cool")) {
            f.$name == f.$name
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INNER JOIN "cool" ON ("x"."name" = "x"."name")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        JOIN(self.f.table) {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = 'tmac')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        JOIN(self.f.table) {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testSwitch() {
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
        .serialize(to: &fluentSerializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true
        JOIN(self.f.table) {
            f.$age == 29
            if bool {
                f.$name == "tmac"
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29) AND ("x"."name" = 'tmac')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false
        JOIN(self.f.table) {
            f.$age == 29
            if bool {
                f.$name == "tmac"
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testEmpty() {
        JOIN(self.f.table) {}
            .serialize(to: &fluentSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
