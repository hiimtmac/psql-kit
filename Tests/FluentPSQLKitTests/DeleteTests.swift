// DeleteTests.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct DeleteTests {
    let f = FluentModel.as("x")

    @Test
    func testModel() {
        var serializer = SQLSerializer.test
        DELETE {
            FluentModel.table
        }
        .serialize(to: &serializer)

        #expect(serializer.sql == #"DELETE FROM "my_model""#)
    }

    @Test
    func testModelAlias() {
        var serializer = SQLSerializer.test
        DELETE {
            f.table
        }
        .serialize(to: &serializer)

        #expect(serializer.sql == #"DELETE FROM "my_model" AS "x""#)
    }

    @Test
    func testBoth() {
        var serializer = SQLSerializer.test
        DELETE {
            f.table
            FluentModel.table
            FluentModel.table.as("cool")
        }
        .serialize(to: &serializer)

        #expect(serializer.sql == #"DELETE FROM "my_model" AS "x", "my_model", "my_model" AS "cool""#)
    }

    @Test
    func testRaw() {
        var serializer = SQLSerializer.test
        DELETE {
            RawTable("tableName")
        }
        .serialize(to: &serializer)

        #expect(serializer.sql == #"DELETE FROM "tableName""#)
    }

    @Test
    func testGenerateSeries() {
        var serializer = SQLSerializer.test
        let date1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!.psqlDate
        let date2 = DateComponents(calendar: .current, year: 2020, month: 01, day: 30).date!.psqlDate

        DELETE {
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day")
        }
        .serialize(to: &serializer)

        let compare = #"DELETE FROM GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL) AS "dates", GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSubquery() {
        var serializer = SQLSerializer.test
        DELETE {
            QUERY {
                SELECT { f.$age }
                FROM { f.table }
            }
            .asSubquery(f.table)
        }
        .serialize(to: &serializer)

        let compare = #"DELETE FROM (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test
        let bool = true
        DELETE {
            if bool {
                f.table
            } else {
                FluentModel.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"DELETE FROM "my_model" AS "x""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test
        let bool = false
        DELETE {
            if bool {
                f.table
            } else {
                FluentModel.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"DELETE FROM "my_model""#
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
            case .one: f.table
            case .two: FluentModel.table
            case .three:
                FluentModel.table
                f.table
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
        DELETE {
            if bool {
                f.table
                FluentModel.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"DELETE FROM "my_model" AS "x", "my_model""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfFalse() {
        var serializer = SQLSerializer.test
        let bool = false
        DELETE {
            FluentModel.table
            if bool {
                f.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"DELETE FROM "my_model""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test
        DELETE {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
