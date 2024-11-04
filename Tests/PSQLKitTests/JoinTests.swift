// JoinTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class JoinTests: PSQLTestCase {
    let p = PSQLModel.as("x")

    func testJoinModel() {
        JOIN(PSQLModel.table) {
            PSQLModel.$name == PSQLModel.$name
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" ON ("my_model"."name" = "my_model"."name")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testJoinModelAlias() {
        JOIN(self.p.table) {
            p.$name == p.$name
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = "x"."name")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testJoinBoth() {
        JOIN(self.p.table, method: .left) {
            p.$name == PSQLModel.$name
            PSQLModel.$name == p.$name
        }
        .serialize(to: &serializer)

        let compare = #"LEFT JOIN "my_model" AS "x" ON ("x"."name" = "my_model"."name") AND ("my_model"."name" = "x"."name")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testJoinN() {
        JOIN(self.p.table) {
            p.$name == p.$name
            p.$name == PSQLModel.$name || p.$name != p.$name
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = "x"."name") AND (("x"."name" = "my_model"."name") OR ("x"."name" != "x"."name"))"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testJoinRaw() {
        JOIN(RawTable("cool")) {
            p.$name == p.$name
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "cool" ON ("x"."name" = "x"."name")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseTrue() {
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
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseFalse() {
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
        XCTAssertEqual(serializer.sql, compare)
    }

    func testSwitch() {
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
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true

        JOIN(self.p.table) {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29) AND ("x"."name" = 'tmac')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false

        JOIN(self.p.table) {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testEmpty() {
        JOIN(self.p.table) {}
            .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
