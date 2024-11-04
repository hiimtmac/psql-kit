// DeleteTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class DeleteTests: PSQLTestCase {
    let p = PSQLModel.as("x")

    func testModel() {
        DELETE {
            PSQLModel.table
        }
        .serialize(to: &serializer)
        
        XCTAssertEqual(serializer.sql, #"DELETE FROM "my_model""#)
    }

    func testModelAlias() {
        DELETE {
            p.table
        }
        .serialize(to: &serializer)
        
        XCTAssertEqual(serializer.sql, #"DELETE FROM "my_model" AS "x""#)
    }

    func testBoth() {
        DELETE {
            p.table
            PSQLModel.table
            PSQLModel.table.as("cool")
        }
        .serialize(to: &serializer)
        
        XCTAssertEqual(serializer.sql, #"DELETE FROM "my_model" AS "x", "my_model", "my_model" AS "cool""#)
    }

    func testRaw() {
        DELETE {
            RawTable("tableName")
        }
        .serialize(to: &serializer)
        
        XCTAssertEqual(serializer.sql, #"DELETE FROM "tableName""#)
    }

    func testGenerateSeries() {
        let date1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!.psqlDate
        let date2 = DateComponents(calendar: .current, year: 2020, month: 01, day: 30).date!.psqlDate

        DELETE {
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day")
        }
        .serialize(to: &serializer)

        let compare = #"DELETE FROM GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL) AS "dates", GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testSubquery() {
        DELETE {
            QUERY {
                SELECT { p.$age }
                FROM { p.table }
            }
            .asSubquery(p.table)
        }
        .serialize(to: &serializer)

        let compare = #"DELETE FROM (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true

        DELETE {
            if bool {
                p.table
            } else {
                PSQLModel.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"DELETE FROM "my_model" AS "x""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false

        DELETE {
            if bool {
                p.table
            } else {
                PSQLModel.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"DELETE FROM "my_model""#
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

        DELETE {
            if bool {
                p.table
                PSQLModel.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"DELETE FROM "my_model" AS "x", "my_model""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false

        DELETE {
            PSQLModel.table
            if bool {
                p.table
            }
        }
        .serialize(to: &serializer)

        let compare = #"DELETE FROM "my_model""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testEmpty() {
        DELETE {}
            .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
