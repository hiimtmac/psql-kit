import XCTest
@testable import PSQLKit
import FluentKit

final class JoinTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testJoinEmpty() {
        JOIN(f.table) {}
        .serialize(to: &fluentSerializer)
        
        JOIN(p.table) {}
        .serialize(to: &psqlkitSerializer)
        
        XCTAssertEqual(fluentSerializer.sql, #""#)
        XCTAssertEqual(psqlkitSerializer.sql, #""#)
    }
    
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
    
    static var allTests = [
        ("testJoinEmpty", testJoinEmpty),
        ("testJoinModel", testJoinModel),
        ("testJoinModelAlias", testJoinModelAlias),
        ("testJoinBoth", testJoinBoth),
        ("testJoinN", testJoinN),
        ("testJoinRaw", testJoinRaw)
    ]
}
