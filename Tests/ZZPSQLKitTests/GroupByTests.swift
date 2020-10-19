import XCTest
@testable import ZZPSQLKit
import FluentKit

final class GroupByTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testGroupModel() {
        let g = GROUPBY {
            MyModel.$name
        }
        
        g.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"GROUP BY "my_model"."name""#)
    }
    
    func testGroupModelAlias() {
        let g = GROUPBY {
            m.$name
        }
        
        g.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"GROUP BY "x"."name""#)
    }
    
    func testGroupBoth() {
        let g = GROUPBY {
            MyModel.$name
            m.$name
        }
        
        g.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"GROUP BY "my_model"."name", "x"."name""#)
    }
    
    func testGroupRaw() {
        let g = GROUPBY {
            RawColumn<String>("cool")
        }
        
        g.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"GROUP BY "cool""#)
    }
    
    static var allTests = [
        ("testGroupModel", testGroupModel),
        ("testGroupModelAlias", testGroupModelAlias),
        ("testGroupBoth", testGroupBoth),
        ("testGroupRaw", testGroupRaw)
    ]
}
