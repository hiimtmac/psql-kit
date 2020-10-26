import XCTest
@testable import PSQLKit
import FluentKit

final class GroupByTests: PSQLTestCase {
    let m = FluentModel.as("x")
    
    func testGroupModel() {
        let g = GROUPBY {
            FluentModel.$name
        }
        
        g.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"GROUP BY "my_model"."name""#)
    }
    
    func testGroupModelAlias() {
        let g = GROUPBY {
            m.$name
        }
        
        g.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"GROUP BY "x"."name""#)
    }
    
    func testGroupBoth() {
        let g = GROUPBY {
            FluentModel.$name
            m.$name
        }
        
        g.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"GROUP BY "my_model"."name", "x"."name""#)
    }
    
    func testGroupRaw() {
        let g = GROUPBY {
            RawColumn<String>("cool")
        }
        
        g.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"GROUP BY "cool""#)
    }
    
    static var allTests = [
        ("testGroupModel", testGroupModel),
        ("testGroupModelAlias", testGroupModelAlias),
        ("testGroupBoth", testGroupBoth),
        ("testGroupRaw", testGroupRaw)
    ]
}
