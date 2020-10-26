import XCTest
@testable import PSQLKit
import FluentKit

final class OrderByTests: PSQLTestCase {
    let m = FluentModel.as("x")
    
    func testOrderModel() {
        let o = ORDERBY {
            FluentModel.$name
        }

        o.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"ORDER BY "my_model"."name""#)
    }
    
    func testOrderModelAlias() {
        let o = ORDERBY {
            m.$name.asc()
        }

        o.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"ORDER BY "x"."name" ASC"#)
    }
    
    func testOrderMultiple() {
        let o = ORDERBY {
            FluentModel.$name.asc()
            m.$name.desc()
            m.$id
        }
        
        o.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"ORDER BY "my_model"."name" ASC, "x"."name" DESC, "x"."id""#)
    }

    func testOrderDirections() {
        let o = ORDERBY {
            m.$name
            FluentModel.$name.asc()
            FluentModel.$name.desc()
            m.$name.order(.asc)
        }
        
        o.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"ORDER BY "x"."name", "my_model"."name" ASC, "my_model"."name" DESC, "x"."name" ASC"#)
    }
    
    func testOrderRaw() {
        let o = ORDERBY {
            RawColumn<String>("cool").desc()
        }
        
        o.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"ORDER BY "cool" DESC"#)
    }
    
    static var allTests = [
        ("testOrderModel", testOrderModel),
        ("testOrderModelAlias", testOrderModelAlias),
        ("testOrderMultiple", testOrderMultiple),
        ("testOrderDirections", testOrderDirections),
        ("testOrderRaw", testOrderRaw)
    ]
}
