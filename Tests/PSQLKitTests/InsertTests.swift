// InsertTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
import PSQLKit

@Suite
struct InsertTests {
    let p = PSQLModel.as("x")

    @Test
    func testModel() {
        var serializer = SQLSerializer.test

        INSERT(into: PSQLModel.table) {
            PSQLModel.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" ("name") VALUES ('hi')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testModelAlias() {
        var serializer = SQLSerializer.test

        INSERT(into: self.p.table) {
            p.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name") VALUES ('hi')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testBoth() {
        var serializer = SQLSerializer.test

        INSERT(into: self.p.table) {
            PSQLModel.$name => "hi"
            p.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name", "name") VALUES ('hi', 'hi')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test

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
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test

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
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfTrue() {
        var serializer = SQLSerializer.test

        let bool = true

        INSERT(into: self.p.table) {
            if bool {
                p.$name => "hi"
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

        INSERT(into: self.p.table) {
            p.$age => 29
            if bool {
                p.$name => "hi"
            }
        }
        .serialize(to: &serializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("age") VALUES (29)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test

        INSERT(into: self.p.table) {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
