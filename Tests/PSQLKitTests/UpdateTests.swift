// UpdateTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class UpdateTests: PSQLTestCase {
    let p = PSQLModel.as("x")

    func testModel() {
        UPDATE(PSQLModel.table) {
            PSQLModel.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" SET "name" = 'hi'"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testModelAlias() {
        UPDATE(self.p.table) {
            p.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi'"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testBoth() {
        UPDATE(self.p.table) {
            PSQLModel.$name => "hi"
            p.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi', "name" = 'hi'"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true

        UPDATE(self.p.table) {
            if bool {
                p.$name => "hi"
            } else {
                p.$age => 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi'"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false

        UPDATE(self.p.table) {
            if bool {
                p.$name => "hi"
            } else {
                p.$age => 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "age" = 29"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testSwitch() {
        enum Test {
            case one
            case two
            case three
        }

        let option = Test.two

        UPDATE(self.p.table) {
            switch option {
            case .one: p.$name => "hi"
            case .two: p.$age => 29
            case .three:
                p.$age => 29
                p.$name => "hi"
            }
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "age" = 29"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testEmpty() {
        UPDATE(p.table) {}
            .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
