import XCTest
@testable import PSQLKit
import FluentKit

final class OrderByTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testOrderModel() {
        let o = ORDERBY {
            MyModel.$name
        }

        o.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"ORDER BY "my_model"."name" ASC"#)
    }
    
    func testOrderModelAlias() {
        let o = ORDERBY {
            m.$name
        }

        o.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"ORDER BY "x"."name" ASC"#)
    }
    
    func testOrderBoth() {
        let o = ORDERBY {
            MyModel.$name
            m.$name
                .direction(.desc)
        }
        
        o.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"ORDER BY "my_model"."name" ASC, "x"."name" DESC"#)
    }
    
    func testOrderN() {
        let o = ORDERBY {
            m.$name
            MyModel.$name
            m.$name
                .direction(.desc)
        }
        
        o.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"ORDER BY "x"."name" ASC, "my_model"."name" ASC, "x"."name" DESC"#)
    }
    
    static var allTests = [
        ("testOrderModel", testOrderModel),
        ("testOrderModelAlias", testOrderModelAlias),
        ("testOrderBoth", testOrderBoth),
        ("testOrderN", testOrderN)
    ]
}
