// FromTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import FluentPSQLKit

final class FromTests: PSQLTestCase {
    let f = FluentModel.as("x")

    func testFromModel() {
        FROM {
            FluentModel.table
        }
        .serialize(to: &fluentSerializer)

        XCTAssertEqual(fluentSerializer.sql, #"FROM "my_model""#)
    }

    func testFromModelAlias() {
        FROM {
            f.table
        }
        .serialize(to: &fluentSerializer)

        XCTAssertEqual(fluentSerializer.sql, #"FROM "my_model" AS "x""#)
    }

    func testFromBoth() {
        FROM {
            f.table
            FluentModel.table
            FluentModel.table.as("cool")
        }
        .serialize(to: &fluentSerializer)

        XCTAssertEqual(fluentSerializer.sql, #"FROM "my_model" AS "x", "my_model", "my_model" AS "cool""#)
    }

    func testFromRaw() {
        FROM {
            RawTable("tableName")
        }
        .serialize(to: &fluentSerializer)

        XCTAssertEqual(fluentSerializer.sql, #"FROM "tableName""#)
    }

    func testFromGenerateSeries() {
        let date1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!.psqlDate
        let date2 = DateComponents(calendar: .current, year: 2020, month: 01, day: 30).date!.psqlDate

        FROM {
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day")
        }
        .serialize(to: &fluentSerializer)

        let compare = #"FROM GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL) AS "dates", GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testSubquery() {
        FROM {
            QUERY {
                SELECT { f.$age }
                FROM { f.table }
            }
            .asSubquery(f.table)
        }
        .serialize(to: &fluentSerializer)

        let compare = #"FROM (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        FROM {
            if bool {
                f.table
            } else {
                FluentModel.table
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"FROM "my_model" AS "x""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        FROM {
            if bool {
                f.table
            } else {
                FluentModel.table
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"FROM "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
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
            case .one: f.table
            case .two: FluentModel.table
            case .three:
                FluentModel.table
                f.table
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"FROM "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true
        FROM {
            FluentModel.table
            if bool {
                f.table
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"FROM "my_model", "my_model" AS "x""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false
        FROM {
            FluentModel.table
            if bool {
                f.table
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"FROM "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testEmpty() {
        FROM {}
            .serialize(to: &fluentSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
