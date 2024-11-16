// FromTests.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import SQLKit
import Testing
import PSQLKit

@Suite
struct FromTests {
    let p = PSQLModel.as("x")

    @Test
    func testFromModel() {
        var serializer = SQLSerializer.test

        FROM {
            PSQLModel.table
        }
        .serialize(to: &serializer)
        #expect(serializer.sql == #"FROM "my_model""#)
    }

    @Test
    func testFromModelAlias() {
        var serializer = SQLSerializer.test

        FROM {
            p.table
        }
        .serialize(to: &serializer)
        #expect(serializer.sql == #"FROM "my_model" AS "x""#)
    }

    @Test
    func testFromBoth() {
        var serializer = SQLSerializer.test

        FROM {
            p.table
            PSQLModel.table
            PSQLModel.table.as("cool")
        }
        .serialize(to: &serializer)
        #expect(serializer.sql == #"FROM "my_model" AS "x", "my_model", "my_model" AS "cool""#)
    }

    @Test
    func testFromRaw() {
        var serializer = SQLSerializer.test

        FROM {
            RawTable("tableName")
        }
        .serialize(to: &serializer)
        #expect(serializer.sql == #"FROM "tableName""#)
    }

    @Test
    func testFromGenerateSeries() {
        var serializer = SQLSerializer.test

        let date1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!.psqlDate
        let date2 = DateComponents(calendar: .current, year: 2020, month: 01, day: 30).date!.psqlDate

        FROM {
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day")
        }
        .serialize(to: &serializer)

        let compare = #"FROM GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL) AS "dates", GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSubquery() {
        var serializer = SQLSerializer.test

        FROM {
            QUERY {
                SELECT { p.$age }
                FROM { p.table }
            }
            .asSubquery(p.table)
        }
        .serialize(to: &serializer)

        let compare = #"FROM (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test

        let bool = true

        FROM {
            if bool {
                p.table
            } else {
                PSQLModel.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"FROM "my_model" AS "x""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test

        let bool = false

        FROM {
            if bool {
                p.table
            } else {
                PSQLModel.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"FROM "my_model""#
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

        FROM {
            switch option {
            case .one: p.table
            case .two: PSQLModel.table
            case .three:
                PSQLModel.table
                p.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"FROM "my_model""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfTrue() {
        var serializer = SQLSerializer.test

        let bool = true

        FROM {
            PSQLModel.table
            if bool {
                p.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"FROM "my_model", "my_model" AS "x""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfFalse() {
        var serializer = SQLSerializer.test

        let bool = false

        FROM {
            PSQLModel.table
            if bool {
                p.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"FROM "my_model""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test

        FROM {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
    
    @Test
    func testSingleAlias() {
        var serializer = SQLSerializer.test
        FROM(p.table)
            .serialize(to: &serializer)

        let compare = #"FROM "my_model" AS "x""#
        #expect(serializer.sql == compare)
    }
    
    @Test
    func testSingleFull() {
        var serializer = SQLSerializer.test
        FROM(PSQLModel.table)
            .serialize(to: &serializer)

        let compare = #"FROM "my_model""#
        #expect(serializer.sql == compare)
    }
}
