// UpdateTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct UpdateTests {
    let f = FluentModel.as("x")

    @Test
	func testModel() {
		var serializer = SQLSerializer.test
        UPDATE(FluentModel.table) {
            FluentModel.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" SET "name" = 'hi'"#
        #expect(serializer.sql == compare)
    }

    @Test
	func testModelAlias() {
		var serializer = SQLSerializer.test
        UPDATE(self.f.table) {
            f.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi'"#
        #expect(serializer.sql == compare)
    }

    @Test
	func testBoth() {
		var serializer = SQLSerializer.test
        UPDATE(self.f.table) {
            FluentModel.$name => "hi"
            f.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi', "name" = 'hi'"#
        #expect(serializer.sql == compare)
    }

    @Test
	func testIfElseTrue() {
		var serializer = SQLSerializer.test
        let bool = true
        UPDATE(self.f.table) {
            if bool {
                f.$name => "hi"
            } else {
                f.$age => 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi'"#
        #expect(serializer.sql == compare)
    }

    @Test
	func testIfElseFalse() {
		var serializer = SQLSerializer.test
        let bool = false
        UPDATE(self.f.table) {
            if bool {
                f.$name => "hi"
            } else {
                f.$age => 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "age" = 29"#
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

        UPDATE(self.f.table) {
            switch option {
            case .one: f.$name => "hi"
            case .two: f.$age => 29
            case .three:
                f.$age => 29
                f.$name => "hi"
            }
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "age" = 29"#
        #expect(serializer.sql == compare)
    }

    @Test
	func testEmpty() {
		var serializer = SQLSerializer.test
        UPDATE(f.table) {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
