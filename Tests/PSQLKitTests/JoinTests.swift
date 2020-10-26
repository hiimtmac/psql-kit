import XCTest
@testable import PSQLKit
import FluentKit

final class JoinTests: PSQLTestCase {
    let m = FluentModel.as("x")
    
    func testJoinModel() {
        let j = JOIN(FluentModel.table) {
            FluentModel.$name == FluentModel.$name
        }

        j.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"INNER JOIN "my_model" ON ("my_model"."name" = "my_model"."name")"#)
    }
    
    func testJoinModelAlias() {
        let j = JOIN(m.table) {
            m.$name == m.$name
        }
        
        j.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"INNER JOIN "my_model" AS "x" ON ("x"."name" = "x"."name")"#)
    }
    
    func testJoinBoth() {
        let j = JOIN(m.table, method: .left) {
            m.$name == FluentModel.$name
            FluentModel.$name == m.$name
        }
        
        j.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"LEFT JOIN "my_model" AS "x" ON ("x"."name" = "my_model"."name") AND ("my_model"."name" = "x"."name")"#)
    }
    
    func testJoinN() {
        let j = JOIN(m.table) {
            m.$name == m.$name
            m.$name == FluentModel.$name || m.$name != m.$name
        }
        
        j.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"INNER JOIN "my_model" AS "x" ON ("x"."name" = "x"."name") AND (("x"."name" = "my_model"."name") OR ("x"."name" != "x"."name"))"#)
    }
    
    func testJoinRaw() {
        let j = JOIN(RawTable("cool")) {
            m.$name == m.$name
        }
        
        j.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"INNER JOIN "cool" ON ("x"."name" = "x"."name")"#)
    }
    
    static var allTests = [
        ("testJoinModel", testJoinModel),
        ("testJoinModelAlias", testJoinModelAlias),
        ("testJoinBoth", testJoinBoth),
        ("testJoinN", testJoinN),
        ("testJoinRaw", testJoinRaw)
    ]
}
