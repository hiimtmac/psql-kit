import XCTest
@testable import PSQLKit
import FluentKit

final class HavingTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testHaving1() {
        let h = HAVING {
            MyModel.$name == MyModel.$name
        }
        
        h.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"HAVING ("my_model"."name"="my_model"."name")"#)
    }
    
    func testHaving2() {
        let h = HAVING {
            m.$name != m.$name
        }
        
        h.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"HAVING ("x"."name"!="x"."name")"#)
    }
    
    func testHavingN() {
        let m = MyModel.as("x")
        
        let h = HAVING {
            MyModel.$name == m.$name
            m.$name == MyModel.$name
            m.$name != m.$name || MyModel.$name != MyModel.$name
        }
        
        h.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"HAVING ("my_model"."name"="x"."name") AND ("x"."name"="my_model"."name") AND (("x"."name"!="x"."name") OR ("my_model"."name"!="my_model"."name"))"#)
    }
    
    static var allTests = [
        ("testHaving1", testHaving1),
        ("testHaving2", testHaving2),
        ("testHavingN", testHavingN)
    ]
}
