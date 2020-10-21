import XCTest
@testable import PSQLKit
import FluentKit

// needed because https://forums.swift.org/t/exported-import-does-not-properly-export-custom-operators/39090/5
infix operator ~~: ComparisonPrecedence
infix operator ...: LogicalConjunctionPrecedence

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
            m.$age >< (20...30)
            m.$age >< ((m.$age)...(m.$age))
        }

        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."age" BETWEEN 20 AND 30) AND ("x"."age" BETWEEN "x"."age" AND "x"."age")"#)
    }
    
    func testNotBetween() {
        let w = WHERE {
            m.$age <> (20...30)
        }

        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."age" NOT BETWEEN 20 AND 30)"#)
    }
    
    func testLiteral() {
        let w = WHERE {
            m.$name == "hello"
            m.$name != "hello"
            m.$age < 29
            m.$age <= 29
            m.$age > 29
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
    
    func testWhereLikes() {
        let w = WHERE {
            m.$name ~~ "like"
            m.$name !~~ "not like"
            m.$name ~~* "ilike"
            m.$name !~~* "not ilike"
        }

        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."name" LIKE 'like') AND ("x"."name" NOT LIKE 'not like') AND ("x"."name" ILIKE 'ilike') AND ("x"."name" NOT ILIKE 'not ilike')"#)
    }
    
    func testWhereTransforms() {
        let w = WHERE {
            m.$name == "hi"
            m.$name.transform(to: Int.self) == 8
            m.$name.transform(to: Int.self) >< (8...9)
        }

        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."name" = 'hi') AND ("x"."name" = 8) AND ("x"."name" BETWEEN 8 AND 9)"#)
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
        ("testWhereBind", testWhereBind),
        ("testWhereLikes", testWhereLikes),
        ("testWhereTransforms", testWhereTransforms)
    ]
}
