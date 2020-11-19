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
        
        XCTAssertEqual(fluentSerializer.sql, #"HAVING "#)
        XCTAssertEqual(psqlkitSerializer.sql, #"HAVING "#)
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
    
    func testIfElseTrue() {
        let bool = true
        HAVING {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
            }
        }
        .serialize(to: &fluentSerializer)
        
        HAVING {
            if bool {
                p.$name == "tmac"
            } else {
                p.$age == 29
            }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"HAVING ("x"."name" = 'tmac')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testIfElseFalse() {
        let bool = false
        HAVING {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
            }
        }
        .serialize(to: &fluentSerializer)
        
        HAVING {
            if bool {
                p.$name == "tmac"
            } else {
                p.$age == 29
            }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"HAVING ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSwitch() {
        enum Test {
            case one
            case two
            case three
        }
        
        let option = Test.two
        
        HAVING {
            switch option {
            case .one: f.$name == "tmac"
            case .two: f.$age == 29
            case .three:
                f.$age == 29
                f.$name == "tmac"
            }
        }
        .serialize(to: &fluentSerializer)
        
        HAVING {
            switch option {
            case .one: p.$name == "tmac"
            case .two: p.$age == 29
            case .three:
                p.$age == 29
                p.$name == "tmac"
            }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"HAVING ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testHavingEmpty", testHavingEmpty),
        ("testHaving1", testHaving1),
        ("testHaving2", testHaving2),
        ("testHavingN", testHavingN),
        ("testIfElseTrue", testIfElseTrue),
        ("testIfElseFalse", testIfElseFalse),
        ("testSwitch", testSwitch)
    ]
}
