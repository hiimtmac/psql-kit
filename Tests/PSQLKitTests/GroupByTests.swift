import XCTest
@testable import PSQLKit
import FluentKit

final class GroupByTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testGroupModel() {
        let g = GROUPBY {
            MyModel.$name
        }
        
        g.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"GROUP BY "my_model"."name""#)
    }
    
    func testGroupModelAlias() {
        let g = GROUPBY {
            m.$name
        }
        
        g.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"GROUP BY "x"."name""#)
    }
    
    func testGroupBoth() {
        let g = GROUPBY {
            MyModel.$name
            m.$name
        }
        
        g.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"GROUP BY "my_model"."name", "x"."name""#)
    }
    
    static var allTests = [
        ("testGroupModel", testGroupModel),
        ("testGroupModelAlias", testGroupModelAlias),
        ("testGroupBoth", testGroupBoth)
    ]
}
