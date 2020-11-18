import XCTest
@testable import PSQLKit
import FluentKit

// needed because https://forums.swift.org/t/exported-import-does-not-properly-export-custom-operators/39090/5
infix operator ~~: ComparisonPrecedence
infix operator ...: LogicalConjunctionPrecedence

final class WhereTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testEmpty() {
        WHERE {}
        .serialize(to: &fluentSerializer)
        
        WHERE {}
        .serialize(to: &psqlkitSerializer)
        
        XCTAssertEqual(fluentSerializer.sql, #""#)
        XCTAssertEqual(psqlkitSerializer.sql, #""#)
    }
    
    func testEqual() {
        WHERE {
            FluentModel.$name == FluentModel.$title
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            PSQLModel.$name == PSQLModel.$title
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("my_model"."name" = "my_model"."title")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
    
    func testMultiple() {
        WHERE {
            FluentModel.$name == f.$title
            f.$name != FluentModel.$title
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            PSQLModel.$name == p.$title
            p.$name != PSQLModel.$title
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("my_model"."name" = "x"."title") AND ("x"."name" != "my_model"."title")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testNotEqual() {
        WHERE {
            f.$name != f.$title
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name != p.$title
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."name" != "x"."title")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testIn() {
        WHERE {
            f.$name <> ["name", "hi"]
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name <> ["name", "hi"]
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."name" NOT IN ('name', 'hi'))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testNotIn() {
        WHERE {
            f.$name >< ["name", "hi"]
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name >< ["name", "hi"]
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."name" IN ('name', 'hi'))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testBetween() {
        WHERE {
            f.$age >< (20...30)
            f.$age >< ((f.$age)...(f.$age))
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$age >< (20...30)
            p.$age >< ((p.$age)...(p.$age))
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."age" BETWEEN 20 AND 30) AND ("x"."age" BETWEEN "x"."age" AND "x"."age")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testNotBetween() {
        WHERE {
            f.$age <> (20...30)
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$age <> (20...30)
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."age" NOT BETWEEN 20 AND 30)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testLiteral() {
        WHERE {
            f.$name == "hello"
            f.$name != "hello"
            f.$age < 29
            f.$age <= 29
            f.$age > 29
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name == "hello"
            p.$name != "hello"
            p.$age < 29
            p.$age <= 29
            p.$age > 29
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."name" = 'hello') AND ("x"."name" != 'hello') AND ("x"."age" < 29) AND ("x"."age" <= 29) AND ("x"."age" > 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testWhereOr() {
        WHERE {
            f.$name <> ["name", "hi"] || FluentModel.$name != FluentModel.$name
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name <> ["name", "hi"] || PSQLModel.$name != PSQLModel.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE (("x"."name" NOT IN ('name', 'hi')) OR ("my_model"."name" != "my_model"."name"))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testWhereRaw() {
        WHERE {
            f.$name == RawColumn<String>("cool")
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name == RawColumn<String>("cool")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."name" = "cool")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testWhereBind() {
        WHERE {
            RawColumn<String>("cool") == PSQLBind("yes")
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            RawColumn<String>("cool") == PSQLBind("yes")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("cool" = $1)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testWhereLikes() {
        WHERE {
            f.$name ~~ "like"
            f.$name !~~ "not like"
            f.$name ~~* "ilike"
            f.$name !~~* "not ilike"
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name ~~ "like"
            p.$name !~~ "not like"
            p.$name ~~* "ilike"
            p.$name !~~* "not ilike"
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."name" LIKE 'like') AND ("x"."name" NOT LIKE 'not like') AND ("x"."name" ILIKE 'ilike') AND ("x"."name" NOT ILIKE 'not ilike')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testWhereTransforms() {
        WHERE {
            f.$name == "hi"
            f.$name.transform(to: Int.self) == 8
            f.$name.transform(to: Int.self) >< (8...9)
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name == "hi"
            p.$name.transform(to: Int.self) == 8
            p.$name.transform(to: Int.self) >< (8...9)
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."name" = 'hi') AND ("x"."name" = 8) AND ("x"."name" BETWEEN 8 AND 9)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testAnyComparrison() {
        let date = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!
        
        WHERE {
            AnyCompareExpression(
                lhs: f.$birthday,
                operator: .between,
                rhs: PSQLRange(from: date.psqlDate, to: date.psqlDate)
            )
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            AnyCompareExpression(
                lhs: p.$birthday,
                operator: .between,
                rhs: PSQLRange(from: date.psqlDate, to: date.psqlDate)
            )
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."birthday" BETWEEN '2020-01-01' AND '2020-01-01')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testWhereControlFlow() {
        let date = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!
        
        enum Type {
            case current
            case missing
        }
        
        let t1 = Type.current
        let t2 = Type.missing
        
        WHERE {
            f.$birthday >< PSQLRange(from: date.psqlDate, to: date.psqlDate)
            
            switch t1 {
            case .current:
                AnyCompareExpression(
                    lhs: f.$birthday,
                    operator: .between,
                    rhs: PSQLRange(from: date.psqlDate, to: date.psqlDate)
                )
            case .missing:
                AnyCompareExpression(
                    lhs: f.$birthday,
                    operator: .between,
                    rhs: PSQLRange(from: date.psqlTimestamp, to: date.psqlTimestamp)
                )
            }
            
            switch t2 {
            case .current:
                AnyCompareExpression(
                    lhs: f.$birthday,
                    operator: .between,
                    rhs: PSQLRange(from: date.psqlDate, to: date.psqlDate)
                )
            case .missing:
                AnyCompareExpression(
                    lhs: f.$birthday,
                    operator: .between,
                    rhs: PSQLRange(from: date.psqlTimestamp, to: date.psqlTimestamp)
                )
            }
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$birthday >< PSQLRange(from: date.psqlDate, to: date.psqlDate)
            
            switch t1 {
            case .current:
                AnyCompareExpression(
                    lhs: p.$birthday,
                    operator: .between,
                    rhs: PSQLRange(from: date.psqlDate, to: date.psqlDate)
                )
            case .missing:
                AnyCompareExpression(
                    lhs: p.$birthday,
                    operator: .between,
                    rhs: PSQLRange(from: date.psqlTimestamp, to: date.psqlTimestamp)
                )
            }
            
            switch t2 {
            case .current:
                AnyCompareExpression(
                    lhs: p.$birthday,
                    operator: .between,
                    rhs: PSQLRange(from: date.psqlDate, to: date.psqlDate)
                )
            case .missing:
                AnyCompareExpression(
                    lhs: p.$birthday,
                    operator: .between,
                    rhs: PSQLRange(from: date.psqlTimestamp, to: date.psqlTimestamp)
                )
            }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."birthday" BETWEEN '2020-01-01' AND '2020-01-01') AND ("x"."birthday" BETWEEN '2020-01-01' AND '2020-01-01') AND ("x"."birthday" BETWEEN '2020-01-01 06:00 AM' AND '2020-01-01 06:00 AM')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testEmpty", testEmpty),
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
        ("testWhereTransforms", testWhereTransforms),
        ("testWhereControlFlow", testWhereControlFlow)
    ]
}
