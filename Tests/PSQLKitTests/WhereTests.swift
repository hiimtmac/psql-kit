import XCTest
@testable import PSQLKit
import FluentKit

final class WhereTests: PSQLTestCase {
    let m = MyModel.as("x")
    
//    func testEqual() {
//        let w = WHERE {
//            MyModel.$name == MyModel.$name
//        }
//        
//        w.serialize(to: &serializer)
//        XCTAssertEqual(serializer.psql, #"WHERE ("my_model"."name"="my_model"."name")"#)
//    }
//    
//    func testNotEqual() {
//        let w = WHERE {
//            m.$name != m.$name
//        }
//        
//        w.serialize(to: &serializer)
//        XCTAssertEqual(serializer.psql, #"WHERE ("x"."name"!="x"."name")"#)
//    }
//    
//    func testIn() {
//        let w = WHERE {
//            m.$name <> ["name", "hi"]
//        }
//        
//        w.serialize(to: &serializer)
//        XCTAssertEqual(serializer.psql, #"WHERE ("x"."name" NOT IN ('name', 'hi'))"#)
//    }
//    
//    func testNotIn() {
//        let w = WHERE {
//            m.$name >< ["name", "hi"]
//        }
//        
//        w.serialize(to: &serializer)
//        XCTAssertEqual(serializer.psql, #"WHERE ("x"."name" IN ('name', 'hi'))"#)
//    }
//    
//    func testBetween() {
//        let w = WHERE {
//            m.$name >><< ("hello", "hi")
//        }
//        
//        w.serialize(to: &serializer)
//        XCTAssertEqual(serializer.psql, #"WHERE ("x"."name" BETWEEN ('hello' AND 'hi'))"#)
//    }
//    
//    func testLiteral() {
//        let w = WHERE {
//            m.$name == "hello"
//            m.$name != "hello"
//            m.$age < 29
//            m.$age <= 29
//            m.$age > 29
//            m.$age >= 29
//            m.$age >><< (29, 30)
//        }
//
//        w.serialize(to: &serializer)
//        XCTAssertEqual(serializer.psql, #"WHERE ("x"."name"='hello') AND ("x"."name"!='hello') AND ("x"."age"<29) AND ("x"."age"<=29) AND ("x"."age">29) AND ("x"."age">=29) AND ("x"."age" BETWEEN (29 AND 30))"#)
//    }
//    
//    func testWhereN() {
//        let w = WHERE {
//            MyModel.$name == m.$name
//            m.$name == MyModel.$name
//            m.$name <> ["name", "hi"] || MyModel.$name != MyModel.$name
//        }
//        
//        w.serialize(to: &serializer)
//        XCTAssertEqual(serializer.psql, #"WHERE ("my_model"."name"="x"."name") AND ("x"."name"="my_model"."name") AND (("x"."name" NOT IN ('name', 'hi')) OR ("my_model"."name"!="my_model"."name"))"#)
//    }
//    
//    static var allTests = [
//        ("testEqual", testEqual),
//        ("testNotEqual", testNotEqual),
//        ("testIn", testIn),
//        ("testNotIn", testNotIn),
//        ("testLiteral", testLiteral),
//        ("testWhereN", testWhereN)
//    ]
}
