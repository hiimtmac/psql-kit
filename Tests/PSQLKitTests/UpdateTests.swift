// UpdateTests.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import SQLKit
import Testing
import PSQLKit

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
    
    @CTE("test")
    struct Test {
        var date: Date
    }
    
    @Test
    func testDate() {
        let date = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone(abbreviation: "UTC"),
            year: 2024,
            month: 11,
            day: 16,
            hour: 11,
            minute: 52,
            second: 30
        ).date!
        
        var serializer = SQLSerializer.test
        UPDATE(Test.table) {
            Test.$date => date
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "test" SET "date" = '2024-11-16 11:52:30 +0000'"#
        #expect(serializer.sql == compare)
    }
}
