import XCTest
@testable import ZZPSQLKit
import FluentKit

final class FromTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testFromModel() {
        let f = FROM {
            MyModel.table
        }
        
        f.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"FROM "my_model""#)
    }
    
    func testFromModelAlias() {
        let f = FROM {
            m.table
        }
        
        f.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"FROM "my_model" AS "x""#)
    }
    
    func testFromBoth() {
        let f = FROM {
            m.table
            MyModel.table
            MyModel.table.as("cool")
        }
        
        f.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"FROM "my_model" AS "x", "my_model", "my_model" AS "cool""#)
    }
    
    func testFromRaw() {
        let f = FROM {
            RawTable("tableName")
        }
        
        f.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"FROM "tableName""#)
    }
    
    func testFromGenerateSeries() {
        let date1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!.psqlDate
        let date2 = DateComponents(calendar: .current, year: 2020, month: 01, day: 30).date!.psqlDate
        
        let f = FROM {
            GENERATE_SERIES(date1...date2, interval: "1 day").as("dates")
            GENERATE_SERIES(date1...date2, interval: "1 day")
        }
        
        f.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"FROM GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::interval) AS "dates", GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::interval)"#)
    }
    
    static var allTests = [
        ("testFromModel", testFromModel),
        ("testFromModelAlias", testFromModelAlias),
        ("testFromBoth", testFromBoth),
        ("testFromRaw", testFromRaw),
        ("testFromGenerateSeries", testFromGenerateSeries)
    ]
}
