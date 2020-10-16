import XCTest
@testable import ZZPSQLKit
import FluentKit

final class WhereTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testEqual() {
        let w = WHERE {
            MyModel.$name == MyModel.$title
        }
        
        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("my_model"."name" = "my_model"."title")"#)
    }
    
    func testMultiple() {
        let w = WHERE {
            MyModel.$name == m.$title
            m.$name != MyModel.$title
        }
        
        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("my_model"."name" = "x"."title") AND ("x"."name" != "my_model"."title")"#)
    }
    
    func testNotEqual() {
        let w = WHERE {
            m.$name != m.$title
        }
        
        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."name" != "x"."title")"#)
    }
    
    func testIn() {
        let w = WHERE {
            m.$name <> ["name", "hi"]
        }

        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."name" NOT IN ('name', 'hi'))"#)
    }
    
    func testNotIn() {
        let w = WHERE {
            m.$name >< ["name", "hi"]
        }

        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."name" IN ('name', 'hi'))"#)
    }
    
    func testBetween() {
        XCTFail("not implemented")
//        let w = WHERE {
//            m.$name >><< ("hello", "hi")
//        }
//
//        w.serialize(to: &serializer)
//        XCTAssertEqual(serializer.sql, #"WHERE ("x"."name" BETWEEN ('hello' AND 'hi'))"#)
    }
    
    func testLiteral() {
        XCTFail("not implemented")
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
//        XCTAssertEqual(serializer.sql, #"WHERE ("x"."name"='hello') AND ("x"."name"!='hello') AND ("x"."age"<29) AND ("x"."age"<=29) AND ("x"."age">29) AND ("x"."age">=29) AND ("x"."age" BETWEEN (29 AND 30))"#)
    }
    
    func testWhereN() {
        XCTFail("not implemented")
//        let w = WHERE {
//            MyModel.$name == m.$name
//            m.$name == MyModel.$name
//            m.$name <> ["name", "hi"] || MyModel.$name != MyModel.$name
//        }
//
//        w.serialize(to: &serializer)
//        XCTAssertEqual(serializer.sql, #"WHERE ("my_model"."name"="x"."name") AND ("x"."name"="my_model"."name") AND (("x"."name" NOT IN ('name', 'hi')) OR ("my_model"."name"!="my_model"."name"))"#)
    }
    
    static var allTests = [
        ("testEqual", testEqual),
        ("testMultiple", testMultiple),
        ("testNotEqual", testNotEqual),
        ("testIn", testIn),
        ("testNotIn", testNotIn),
        ("testLiteral", testLiteral),
        ("testWhereN", testWhereN)
    ]
}
