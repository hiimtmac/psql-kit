// UpdateTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class UpdateTests: PSQLTestCase {
    let f = FluentModel.as("x")

    func testModel() {
        UPDATE(FluentModel.table) {
            FluentModel.$name => "hi"
        }
        .serialize(to: &fluentSerializer)

        let compare = #"UPDATE "my_model" SET "name" = 'hi'"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testModelAlias() {
        UPDATE(self.f.table) {
            f.$name => "hi"
        }
        .serialize(to: &fluentSerializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi'"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testBoth() {
        UPDATE(self.f.table) {
            FluentModel.$name => "hi"
            f.$name => "hi"
        }
        .serialize(to: &fluentSerializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi', "name" = 'hi'"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        UPDATE(self.f.table) {
            if bool {
                f.$name => "hi"
            } else {
                f.$age => 29
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi'"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        UPDATE(self.f.table) {
            if bool {
                f.$name => "hi"
            } else {
                f.$age => 29
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"UPDATE "my_model" AS "x" SET "age" = 29"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testSwitch() {
        enum Test {
            case one
            case two
            case three
        }

        let option = Test.two

        UPDATE(self.f.table) {
            switch option {
            case .one: f.$name => "hi"
            case .two: f.$age => 29
            case .three:
                f.$age => 29
                f.$name => "hi"
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"UPDATE "my_model" AS "x" SET "age" = 29"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testEmpty() {
        UPDATE(f.table) {}
            .serialize(to: &fluentSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
