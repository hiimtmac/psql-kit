// InsertTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class InsertTests: PSQLTestCase {
    let f = FluentModel.as("x")

    func testModel() {
        INSERT(into: FluentModel.table) {
            FluentModel.$name => "hi"
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INSERT INTO "my_model" ("name") VALUES ('hi')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testModelAlias() {
        INSERT(into: self.f.table) {
            f.$name => "hi"
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name") VALUES ('hi')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testBoth() {
        INSERT(into: self.f.table) {
            FluentModel.$name => "hi"
            f.$name => "hi"
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name", "name") VALUES ('hi', 'hi')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        INSERT(into: self.f.table) {
            if bool {
                f.$name => "hi"
            } else {
                f.$age => 29
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name") VALUES ('hi')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        INSERT(into: self.f.table) {
            if bool {
                f.$name => "hi"
            } else {
                f.$age => 29
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("age") VALUES (29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testSwitch() {
        enum Test {
            case one
            case two
            case three
        }

        let option = Test.two

        INSERT(into: self.f.table) {
            switch option {
            case .one: f.$name => "hi"
            case .two: f.$age => 29
            case .three:
                f.$age => 29
                f.$name => "hi"
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("age") VALUES (29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true
        INSERT(into: self.f.table) {
            if bool {
                f.$name => "hi"
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name") VALUES ('hi')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false
        INSERT(into: self.f.table) {
            f.$age => 29
            if bool {
                f.$name => "hi"
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("age") VALUES (29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testEmpty() {
        INSERT(into: self.f.table) {}
            .serialize(to: &fluentSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
