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
    
    func testFromGenerateSeries() {
        XCTFail("Not implemented")
//        let d = DateComponents(calendar: .current, year: 2020, month: 07, day: 31).date!
//        let f = FROM {
//            GENERATE_SERIES(from: SimpleDate(d), to: SimpleDate(d), interval: "1 day")
//            GENERATE_SERIES(from: 1, to: 5, interval: 1)
//        }
//
//        f.serialize(to: &serializer)
//        XCTAssertEqual(serializer.sql, #"FROM GENERATE_SERIES('2020-07-31', '2020-07-31', '1 day'::interval), GENERATE_SERIES(1, 5, 1::interval)"#)
    }
    
    static var allTests = [
        ("testFromModel", testFromModel),
        ("testFromModelAlias", testFromModelAlias),
        ("testFromBoth", testFromBoth),
        ("testFromGenerateSeries", testFromGenerateSeries)
    ]
}
