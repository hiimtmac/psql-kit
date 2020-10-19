import XCTest
@testable import PSQLKit
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
        let w = WHERE {
            m.$age >< 20...30
        }

        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."age" BETWEEN (20 AND 30))"#)
    }
    
    func testNotBetween() {
        let w = WHERE {
            m.$age <> 20...30
        }

        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."age" NOT BETWEEN (20 AND 30))"#)
    }
    
    func testLiteral() {
        let w = WHERE {
            m.$name == "hello"
            m.$name != "hello"
            m.$age < 29
            m.$age <= 29
            m.$age > 29
//            m.$age >= 29 // only can support 5 right now
//            m.$age >< 29...30 // only can support 5 right now
        }

        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."name" = 'hello') AND ("x"."name" != 'hello') AND ("x"."age" < 29) AND ("x"."age" <= 29) AND ("x"."age" > 29)"#)
    }
    
    func testWhereOr() {
        let w = WHERE {
            m.$name <> ["name", "hi"] || MyModel.$name != MyModel.$name
        }

        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE (("x"."name" NOT IN ('name', 'hi')) OR ("my_model"."name" != "my_model"."name"))"#)
    }
    
    func testWhereRaw() {
        let w = WHERE {
            m.$name == RawColumn<String>("cool")
        }

        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."name" = "cool")"#)
    }
    
    func testWhereBind() {
        let w = WHERE {
            RawColumn<String>("cool") == PSQLBind("yes")
        }

        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("cool" = $1)"#)
    }
    
    static var allTests = [
        ("testEqual", testEqual),
        ("testMultiple", testMultiple),
        ("testNotEqual", testNotEqual),
        ("testIn", testIn),
        ("testNotIn", testNotIn),
        ("testLiteral", testLiteral),
        ("testWhereOr", testWhereOr),
        ("testWhereRaw", testWhereRaw),
        ("testWhereBind", testWhereBind)
    ]
}
