import XCTest
@testable import PSQLKit
import FluentKit

final class JoinTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testJoinModel() {
        let j = JOIN(MyModel.table) {
            MyModel.$name == MyModel.$name
        }

        j.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"INNER JOIN "my_model" ON ("my_model"."name"="my_model"."name")"#)
    }
    
    func testJoinModelAlias() {
        let j = JOIN(m.table) {
            m.$name == m.$name
        }
        
        j.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"INNER JOIN "my_model" AS "x" ON ("x"."name"="x"."name")"#)
    }
    
    func testJoinBoth() {
        let j = JOIN(m.table, type: .left) {
            m.$name == MyModel.$name
            MyModel.$name == m.$name
        }
        
        j.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"LEFT JOIN "my_model" AS "x" ON ("x"."name"="my_model"."name") AND ("my_model"."name"="x"."name")"#)
    }
    
    func testJoinDir() {
        let j = JOIN(m.table) {
            m.$name == MyModel.$name
            MyModel.$name == m.$name
        }
        .type(.outer)
        
        j.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"OUTER JOIN "my_model" AS "x" ON ("x"."name"="my_model"."name") AND ("my_model"."name"="x"."name")"#)
    }
    
    func testJoinN() {
        let j = JOIN(m.table) {
            m.$name == m.$name
            m.$name == MyModel.$name || m.$name != m.$name
        }
        
        j.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"INNER JOIN "my_model" AS "x" ON ("x"."name"="x"."name") AND (("x"."name"="my_model"."name") OR ("x"."name"!="x"."name"))"#)
    }
    
    static var allTests = [
        ("testJoinModel", testJoinModel),
        ("testJoinModelAlias", testJoinModelAlias),
        ("testJoinBoth", testJoinBoth),
        ("testJoinDir", testJoinDir),
        ("testJoinN", testJoinN),
    ]
}
