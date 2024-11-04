// InsertTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class InsertTests: PSQLTestCase {
    let p = PSQLModel.as("x")

    func testModel() {
        INSERT(into: PSQLModel.table) {
            PSQLModel.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" ("name") VALUES ('hi')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testModelAlias() {
        INSERT(into: self.p.table) {
            p.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name") VALUES ('hi')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testBoth() {
        INSERT(into: self.p.table) {
            PSQLModel.$name => "hi"
            p.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name", "name") VALUES ('hi', 'hi')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true

        INSERT(into: self.p.table) {
            if bool {
                p.$name => "hi"
            } else {
                p.$age => 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name") VALUES ('hi')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false

        INSERT(into: self.p.table) {
            if bool {
                p.$name => "hi"
            } else {
                p.$age => 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("age") VALUES (29)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testSwitch() {
        enum Test {
            case one
            case two
            case three
        }

        let option = Test.two

        INSERT(into: self.p.table) {
            switch option {
            case .one: p.$name => "hi"
            case .two: p.$age => 29
            case .three:
                p.$age => 29
                p.$name => "hi"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("age") VALUES (29)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true

        INSERT(into: self.p.table) {
            if bool {
                p.$name => "hi"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name") VALUES ('hi')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false

        INSERT(into: self.p.table) {
            p.$age => 29
            if bool {
                p.$name => "hi"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("age") VALUES (29)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testEmpty() {
        INSERT(into: self.p.table) {}
            .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
