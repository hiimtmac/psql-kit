import XCTest
@testable import PSQLKit
import FluentKit

final class OrderByTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testOrderEmpty() {
        ORDERBY {}
        .serialize(to: &fluentSerializer)
        
        ORDERBY {}
        .serialize(to: &psqlkitSerializer)
        
        XCTAssertEqual(fluentSerializer.sql, #""#)
        XCTAssertEqual(psqlkitSerializer.sql, #""#)
    }
    
    func testOrderModel() {
        ORDERBY {
            FluentModel.$name
        }
        .serialize(to: &fluentSerializer)
        
        ORDERBY {
            PSQLModel.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"ORDER BY "my_model"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testOrderModelAlias() {
        ORDERBY {
            f.$name.asc()
        }
        .serialize(to: &fluentSerializer)
        
        ORDERBY {
            p.$name.asc()
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"ORDER BY "x"."name" ASC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testOrderMultiple() {
        ORDERBY {
            FluentModel.$name.asc()
            f.$name.desc()
            f.$id
        }
        .serialize(to: &fluentSerializer)
        
        ORDERBY {
            PSQLModel.$name.asc()
            p.$name.desc()
            p.$id
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"ORDER BY "my_model"."name" ASC, "x"."name" DESC, "x"."id""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testOrderDirections() {
        ORDERBY {
            f.$name
            FluentModel.$name.asc()
            FluentModel.$name.desc()
            f.$name.order(.asc)
        }
        .serialize(to: &fluentSerializer)
        
        ORDERBY {
            p.$name
            PSQLModel.$name.asc()
            PSQLModel.$name.desc()
            p.$name.order(.asc)
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"ORDER BY "x"."name", "my_model"."name" ASC, "my_model"."name" DESC, "x"."name" ASC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testOrderRaw() {
        ORDERBY {
            RawColumn<String>("cool").desc()
        }
        .serialize(to: &fluentSerializer)
        
        ORDERBY {
            RawColumn<String>("cool").desc()
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"ORDER BY "cool" DESC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testOrderEmpty", testOrderEmpty),
        ("testOrderModel", testOrderModel),
        ("testOrderModelAlias", testOrderModelAlias),
        ("testOrderMultiple", testOrderMultiple),
        ("testOrderDirections", testOrderDirections),
        ("testOrderRaw", testOrderRaw)
    ]
}
