import XCTest
@testable import PSQLKit
import FluentKit

final class HavingTests: PSQLTestCase {
    let m = FluentModel.as("x")
    
    func testHaving1() {
        let h = HAVING {
            FluentModel.$name == FluentModel.$title
        }
        
        h.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"HAVING ("my_model"."name" = "my_model"."title")"#)
    }
    
    func testHaving2() {
        let h = HAVING {
            m.$name != m.$name
        }
        
        h.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"HAVING ("x"."name" != "x"."name")"#)
    }
    
    func testHavingN() {
        let m = FluentModel.as("x")
        
        let h = HAVING {
            FluentModel.$name == m.$name
            m.$name == FluentModel.$name
            m.$name != m.$name || FluentModel.$name != FluentModel.$name
        }
        
        h.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"HAVING ("my_model"."name" = "x"."name") AND ("x"."name" = "my_model"."name") AND (("x"."name" != "x"."name") OR ("my_model"."name" != "my_model"."name"))"#)
    }
    
    static var allTests = [
        ("testHaving1", testHaving1),
        ("testHaving2", testHaving2),
        ("testHavingN", testHavingN)
    ]
}
