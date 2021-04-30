import XCTest
@testable import PSQLKit
import FluentKit

final class DeleteTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testModel() {
        DELETE {
            FluentModel.table
        }
        .serialize(to: &fluentSerializer)
        
        DELETE {
            PSQLModel.table
        }
        .serialize(to: &psqlkitSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"DELETE FROM "my_model""#)
        XCTAssertEqual(psqlkitSerializer.sql, #"DELETE FROM "my_model""#)
    }
    
    func testModelAlias() {
        DELETE {
            f.table
        }
        .serialize(to: &fluentSerializer)

        DELETE {
            p.table
        }
        .serialize(to: &psqlkitSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"DELETE FROM "my_model" AS "x""#)
        XCTAssertEqual(psqlkitSerializer.sql, #"DELETE FROM "my_model" AS "x""#)
    }

    func testBoth() {
        DELETE {
            f.table
            FluentModel.table
            FluentModel.table.as("cool")
        }
        .serialize(to: &fluentSerializer)

        DELETE {
            p.table
            PSQLModel.table
            PSQLModel.table.as("cool")
        }
        .serialize(to: &psqlkitSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"DELETE FROM "my_model" AS "x", "my_model", "my_model" AS "cool""#)
        XCTAssertEqual(psqlkitSerializer.sql, #"DELETE FROM "my_model" AS "x", "my_model", "my_model" AS "cool""#)
    }

    func testRaw() {
        DELETE {
            RawTable("tableName")
        }
        .serialize(to: &fluentSerializer)

        DELETE {
            RawTable("tableName")
        }
        .serialize(to: &psqlkitSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"DELETE FROM "tableName""#)
        XCTAssertEqual(psqlkitSerializer.sql, #"DELETE FROM "tableName""#)
    }

    func testGenerateSeries() {
        let date1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!.psqlDate
        let date2 = DateComponents(calendar: .current, year: 2020, month: 01, day: 30).date!.psqlDate

        DELETE {
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day")
        }
        .serialize(to: &fluentSerializer)

        DELETE {
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"DELETE FROM GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL) AS "dates", GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testSubquery() {
        DELETE {
            QUERY {
                SELECT { f.$age }
                FROM { f.table }
            }
            .asSubquery(f.table)
        }
        .serialize(to: &fluentSerializer)

        DELETE {
            QUERY {
                SELECT { p.$age }
                FROM { p.table }
            }
            .asSubquery(p.table)
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"DELETE FROM (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        DELETE {
            if bool {
                f.table
            } else {
                FluentModel.table
            }
        }
        .serialize(to: &fluentSerializer)

        DELETE {
            if bool {
                p.table
            } else {
                PSQLModel.table
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"DELETE FROM "my_model" AS "x""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        DELETE {
            if bool {
                f.table
            } else {
                FluentModel.table
            }
        }
        .serialize(to: &fluentSerializer)

        DELETE {
            if bool {
                p.table
            } else {
                PSQLModel.table
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"DELETE FROM "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
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

        FROM {
            switch option {
            case .one: p.table
            case .two: PSQLModel.table
            case .three:
                PSQLModel.table
                p.table
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"FROM "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testIfTrue() {
        let bool = true
        DELETE {
            if bool {
                f.table
                FluentModel.table
            }
        }
        .serialize(to: &fluentSerializer)

        DELETE {
            if bool {
                p.table
                PSQLModel.table
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"DELETE FROM "my_model" AS "x", "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false
        DELETE {
            FluentModel.table
            if bool {
                f.table
            }
        }
        .serialize(to: &fluentSerializer)

        DELETE {
            PSQLModel.table
            if bool {
                p.table
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"DELETE FROM "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testModel", testModel),
        ("testModelAlias", testModelAlias),
        ("testBoth", testBoth),
        ("testRaw", testRaw),
        ("testGenerateSeries", testGenerateSeries),
        ("testSubquery", testSubquery),
        ("testIfElseTrue", testIfElseTrue),
        ("testIfElseFalse", testIfElseFalse),
        ("testSwitch", testSwitch),
        ("testIfTrue", testIfTrue),
        ("testIfFalse", testIfFalse),
    ]
}
