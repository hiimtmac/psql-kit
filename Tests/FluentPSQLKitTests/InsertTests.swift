// InsertTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct InsertTests {
    let f = FluentModel.as("x")

    @Test
    func testModel() {
        var serializer = SQLSerializer.test
        INSERT(into: FluentModel.table) {
            FluentModel.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" ("name") VALUES ('hi')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testModelAlias() {
        var serializer = SQLSerializer.test
        INSERT(into: self.f.table) {
            f.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name") VALUES ('hi')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testBoth() {
        var serializer = SQLSerializer.test
        INSERT(into: self.f.table) {
            FluentModel.$name => "hi"
            f.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name", "name") VALUES ('hi', 'hi')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test
        let bool = true
        INSERT(into: self.f.table) {
            if bool {
                f.$name => "hi"
            } else {
                f.$age => 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name") VALUES ('hi')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test
        let bool = false
        INSERT(into: self.f.table) {
            if bool {
                f.$name => "hi"
            } else {
                f.$age => 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("age") VALUES (29)"#
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

        INSERT(into: self.f.table) {
            switch option {
            case .one: f.$name => "hi"
            case .two: f.$age => 29
            case .three:
                f.$age => 29
                f.$name => "hi"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("age") VALUES (29)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfTrue() {
        var serializer = SQLSerializer.test
        let bool = true
        INSERT(into: self.f.table) {
            if bool {
                f.$name => "hi"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name") VALUES ('hi')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfFalse() {
        var serializer = SQLSerializer.test
        let bool = false
        INSERT(into: self.f.table) {
            f.$age => 29
            if bool {
                f.$name => "hi"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("age") VALUES (29)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test
        INSERT(into: self.f.table) {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
