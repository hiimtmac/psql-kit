// UpdateTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import PSQLKit

@Suite
struct UpdateTests {
    let p = PSQLModel.as("x")

    @Test
    func testModel() {
        var serializer = SQLSerializer.test
        
        UPDATE(PSQLModel.table) {
            PSQLModel.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" SET "name" = 'hi'"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testModelAlias() {
        var serializer = SQLSerializer.test
        
        UPDATE(self.p.table) {
            p.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi'"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testBoth() {
        var serializer = SQLSerializer.test
        
        UPDATE(self.p.table) {
            PSQLModel.$name => "hi"
            p.$name => "hi"
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi', "name" = 'hi'"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test
        
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
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test
        
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
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test
        
        UPDATE(p.table) {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
