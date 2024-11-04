// FromTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class FromTests: PSQLTestCase {
    let p = PSQLModel.as("x")

    func testFromModel() {
        FROM {
            PSQLModel.table
        }
        .serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"FROM "my_model""#)
    }

    func testFromModelAlias() {
        FROM {
            p.table
        }
        .serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"FROM "my_model" AS "x""#)
    }

    func testFromBoth() {
        FROM {
            p.table
            PSQLModel.table
            PSQLModel.table.as("cool")
        }
        .serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"FROM "my_model" AS "x", "my_model", "my_model" AS "cool""#)
    }

    func testFromRaw() {
        FROM {
            RawTable("tableName")
        }
        .serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"FROM "tableName""#)
    }

    func testFromGenerateSeries() {
        let date1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!.psqlDate
        let date2 = DateComponents(calendar: .current, year: 2020, month: 01, day: 30).date!.psqlDate

        FROM {
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day")
        }
        .serialize(to: &serializer)

        let compare = #"FROM GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL) AS "dates", GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testSubquery() {
        FROM {
            QUERY {
                SELECT { p.$age }
                FROM { p.table }
            }
            .asSubquery(p.table)
        }
        .serialize(to: &serializer)

        let compare = #"FROM (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseTrue() {
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
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseFalse() {
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
        XCTAssertEqual(serializer.sql, compare)
    }

    func testSwitch() {
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
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true

        FROM {
            PSQLModel.table
            if bool {
                p.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"FROM "my_model", "my_model" AS "x""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false

        FROM {
            PSQLModel.table
            if bool {
                p.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"FROM "my_model""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testEmpty() {
        FROM {}
            .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
