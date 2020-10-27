import XCTest
@testable import PSQLKit
import FluentKit

final class GroupByTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testGroupModel() {
        GROUPBY {
            FluentModel.$name
        }
        .serialize(to: &fluentSerializer)
        
        GROUPBY {
            PSQLModel.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"GROUP BY "my_model"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testGroupModelAlias() {
        GROUPBY {
            f.$name
        }
        .serialize(to: &fluentSerializer)
        
        GROUPBY {
            p.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"GROUP BY "x"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testGroupBoth() {
        GROUPBY {
            FluentModel.$name
            f.$name
        }
        .serialize(to: &fluentSerializer)
        
        GROUPBY {
            PSQLModel.$name
            p.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"GROUP BY "my_model"."name", "x"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testGroupRaw() {
        GROUPBY {
            RawColumn<String>("cool")
        }
        .serialize(to: &fluentSerializer)
        
        GROUPBY {
            RawColumn<String>("cool")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"GROUP BY "cool""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testGroupModel", testGroupModel),
        ("testGroupModelAlias", testGroupModelAlias),
        ("testGroupBoth", testGroupBoth),
        ("testGroupRaw", testGroupRaw)
    ]
}
