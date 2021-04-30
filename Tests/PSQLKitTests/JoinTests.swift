import XCTest
@testable import PSQLKit
import FluentKit

final class JoinTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testJoinModel() {
        JOIN(FluentModel.table) {
            FluentModel.$name == FluentModel.$name
        }
        .serialize(to: &fluentSerializer)
        
        JOIN(PSQLModel.table) {
            PSQLModel.$name == PSQLModel.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"INNER JOIN "my_model" ON ("my_model"."name" = "my_model"."name")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testJoinModelAlias() {
        JOIN(f.table) {
            f.$name == f.$name
        }
    
        .serialize(to: &fluentSerializer)
        
        JOIN(p.table) {
            p.$name == p.$name
        }
    
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = "x"."name")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testJoinBoth() {
        JOIN(f.table, method: .left) {
            f.$name == FluentModel.$name
            FluentModel.$name == f.$name
        }
        .serialize(to: &fluentSerializer)
        
        JOIN(p.table, method: .left) {
            p.$name == PSQLModel.$name
            PSQLModel.$name == p.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"LEFT JOIN "my_model" AS "x" ON ("x"."name" = "my_model"."name") AND ("my_model"."name" = "x"."name")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testJoinN() {
        JOIN(f.table) {
            f.$name == f.$name
            f.$name == FluentModel.$name || f.$name != f.$name
        }
        .serialize(to: &fluentSerializer)
        
        JOIN(p.table) {
            p.$name == p.$name
            p.$name == PSQLModel.$name || p.$name != p.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = "x"."name") AND (("x"."name" = "my_model"."name") OR ("x"."name" != "x"."name"))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testJoinRaw() {
        JOIN(RawTable("cool")) {
            f.$name == f.$name
        }
        .serialize(to: &fluentSerializer)
        
        JOIN(RawTable("cool")) {
            p.$name == p.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"INNER JOIN "cool" ON ("x"."name" = "x"."name")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testIfElseTrue() {
        let bool = true
        JOIN(f.table) {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
            }
        }
        .serialize(to: &fluentSerializer)
        
        JOIN(p.table) {
            if bool {
                p.$name == "tmac"
            } else {
                p.$age == 29
            }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."name" = 'tmac')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testIfElseFalse() {
        let bool = false
        JOIN(f.table) {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
            }
        }
        .serialize(to: &fluentSerializer)
        
        JOIN(p.table) {
            if bool {
                p.$name == "tmac"
            } else {
                p.$age == 29
            }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29)"#
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
        
        JOIN(f.table) {
            switch option {
            case .one: f.$name == "tmac"
            case .two: f.$age == 29
            case .three:
                f.$age == 29
                f.$name == "tmac"
            }
        }
        .serialize(to: &fluentSerializer)
        
        JOIN(p.table) {
            switch option {
            case .one: p.$name == "tmac"
            case .two: p.$age == 29
            case .three:
                p.$age == 29
                p.$name == "tmac"
            }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testIfTrue() {
        let bool = true
        JOIN(f.table) {
            f.$age == 29
            if bool {
                f.$name == "tmac"
            }
        }
        .serialize(to: &fluentSerializer)
        
        JOIN(p.table) {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29) AND ("x"."name" = 'tmac')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testIfFalse() {
        let bool = false
        JOIN(f.table) {
            f.$age == 29
            if bool {
                f.$name == "tmac"
            }
        }
        .serialize(to: &fluentSerializer)
        
        JOIN(p.table) {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"INNER JOIN "my_model" AS "x" ON ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testJoinModel", testJoinModel),
        ("testJoinModelAlias", testJoinModelAlias),
        ("testJoinBoth", testJoinBoth),
        ("testJoinN", testJoinN),
        ("testJoinRaw", testJoinRaw),
        ("testIfElseTrue", testIfElseTrue),
        ("testIfElseFalse", testIfElseFalse),
        ("testSwitch", testSwitch),
        ("testIfTrue", testIfTrue),
        ("testIfFalse", testIfFalse),
    ]
}
