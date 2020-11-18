import XCTest
@testable import PSQLKit
import FluentKit

final class HavingTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testHavingEmpty() {
        HAVING {}
        .serialize(to: &fluentSerializer)
        
        HAVING {}
        .serialize(to: &psqlkitSerializer)
        
        XCTAssertEqual(fluentSerializer.sql, #""#)
        XCTAssertEqual(psqlkitSerializer.sql, #""#)
    }
    
    func testHaving1() {
        HAVING {
            FluentModel.$name == FluentModel.$title
        }
        .serialize(to: &fluentSerializer)
        
        HAVING {
            PSQLModel.$name == PSQLModel.$title
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"HAVING ("my_model"."name" = "my_model"."title")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testHaving2() {
        HAVING {
            f.$name != f.$name
        }
        .serialize(to: &fluentSerializer)
        
        HAVING {
            p.$name != p.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"HAVING ("x"."name" != "x"."name")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testHavingN() {
        HAVING {
            FluentModel.$name == f.$name
            f.$name == FluentModel.$name
            f.$name != f.$name || FluentModel.$name != FluentModel.$name
        }
        .serialize(to: &fluentSerializer)
        
        HAVING {
            PSQLModel.$name == p.$name
            p.$name == PSQLModel.$name
            p.$name != p.$name || PSQLModel.$name != PSQLModel.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"HAVING ("my_model"."name" = "x"."name") AND ("x"."name" = "my_model"."name") AND (("x"."name" != "x"."name") OR ("my_model"."name" != "my_model"."name"))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testHavingEmpty", testHavingEmpty),
        ("testHaving1", testHaving1),
        ("testHaving2", testHaving2),
        ("testHavingN", testHavingN)
    ]
}
