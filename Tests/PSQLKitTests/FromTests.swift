import XCTest
@testable import PSQLKit
import FluentKit

final class FromTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testFromModel() {
        FROM {
            FluentModel.table
        }
        .serialize(to: &fluentSerializer)
        
        FROM {
            PSQLModel.table
        }
        .serialize(to: &psqlkitSerializer)
        
        XCTAssertEqual(fluentSerializer.sql, #"FROM "my_model""#)
    }
    
    func testFromModelAlias() {
        FROM {
            f.table
        }
        .serialize(to: &fluentSerializer)
        
        FROM {
            p.table
        }
        .serialize(to: &psqlkitSerializer)
        
        XCTAssertEqual(fluentSerializer.sql, #"FROM "my_model" AS "x""#)
    }
    
    func testFromBoth() {
        FROM {
            f.table
            FluentModel.table
            FluentModel.table.as("cool")
        }
        .serialize(to: &fluentSerializer)
        
        FROM {
            p.table
            PSQLModel.table
            PSQLModel.table.as("cool")
        }
        .serialize(to: &psqlkitSerializer)
        
        XCTAssertEqual(fluentSerializer.sql, #"FROM "my_model" AS "x", "my_model", "my_model" AS "cool""#)
    }
    
    func testFromRaw() {
        FROM {
            RawTable("tableName")
        }
        .serialize(to: &fluentSerializer)
        
        FROM {
            RawTable("tableName")
        }
        .serialize(to: &psqlkitSerializer)
        
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
        
        FROM {
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"FROM GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL) AS "dates", GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
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
        
        FROM {
            QUERY {
                SELECT { p.$age }
                FROM { p.table }
            }
            .asSubquery(p.table)
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"FROM (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testFromModel", testFromModel),
        ("testFromModelAlias", testFromModelAlias),
        ("testFromBoth", testFromBoth),
        ("testFromRaw", testFromRaw),
        ("testFromGenerateSeries", testFromGenerateSeries),
        ("testSubquery", testSubquery)
    ]
}
