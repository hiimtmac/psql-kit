import XCTest
@testable import PSQLKit
import FluentKit

final class ExpressionTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testMax() {
        let s = SELECT {
            MAX(MyModel.$name)
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"SELECT MAX("my_model"."name")"#)
    }
    
    func testMin() {
        let s = SELECT {
            MIN(m.$name)
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"SELECT MIN("x"."name")"#)
    }
    
    func testSum() {
        let s = SELECT {
            SUM(m.$name)
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"SELECT SUM("x"."name")"#)
    }
    
    func testConcat() {
        let s = SELECT {
            CONCAT(m.$name, " ", m.$name)
            CONCAT(8, 8, 10)
        }

        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"SELECT CONCAT("x"."name", ' ', "x"."name"), CONCAT(8, 8, 10)"#)
    }
    
    func testCoalesce() {
        let s = SELECT {
            COALESCE(m.$name, "hello")
            COALESCE(m.$name, COALESCE(m.$name, "hello"))
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"SELECT COALESCE("x"."name", 'hello'), COALESCE("x"."name", COALESCE("x"."name", 'hello'))"#)
    }
    
    static var allTests = [
        ("testMax", testMax),
        ("testMin", testMin),
        ("testSum", testSum),
        ("testConcat", testConcat),
        ("testCoalesce", testCoalesce)
    ]
}
