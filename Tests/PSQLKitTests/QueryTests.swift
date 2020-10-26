import XCTest
@testable import PSQLKit
import FluentKit

final class QueryTests: PSQLTestCase {
    let m = FluentModel.as("x")
    
    func testQuery() {
        let q = QUERY {
            SELECT { m.$name }
            FROM { m.table }
        }
        
        q.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT "x"."name"::TEXT FROM "my_model" AS "x""#)
    }
    
    func testQueryAsSub() {
        let q = QUERY {
            SELECT { m.$name }
            FROM { m.table }
        }
        .asSubquery(FluentModel.table)
        
        q.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"(SELECT "x"."name"::TEXT FROM "my_model" AS "x") AS "my_model""#)
    }
    
    func testQueryAsWith() {
        let q = QUERY {
            SELECT { m.$name }
            FROM { m.table }
        }
        .asWith(m.table)
        
        q.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #""x" AS (SELECT "x"."name"::TEXT FROM "my_model" AS "x")"#)
    }
    
    func testQueryN() {
        let q = QUERY {
            SELECT {
                m.$name
                m.$title
            }
            FROM { m.table }
            GROUPBY { m.$name }
            ORDERBY { m.$name.desc() }
        }
        
        q.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT "x"."name"::TEXT, "x"."title"::TEXT FROM "my_model" AS "x" GROUP BY "x"."name" ORDER BY "x"."name" DESC"#)
    }
    
    func testUnion() {
        let q = QUERY {
            UNION {
                QUERY { SELECT { m.$name } }
                QUERY { SELECT { m.$name } }
                QUERY { SELECT { m.$name } }
            }
        }
        
        q.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT "x"."name"::TEXT UNION SELECT "x"."name"::TEXT UNION SELECT "x"."name"::TEXT"#)
    }
    
    static var allTests = [
        ("testQuery", testQuery),
        ("testQueryAsSub", testQueryAsSub),
        ("testQueryAsWith", testQueryAsWith),
        ("testQueryN", testQueryN),
        ("testUnion", testUnion)
    ]
}
