import XCTest
@testable import ZZPSQLKit
import FluentKit

final class QueryTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testQuery() {
        let q = QUERY {
            SELECT { m.$name }
            FROM { m.table }
        }
        
        q.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT "x"."name"::TEXT FROM "my_model" AS "x""#)
    }
    
    func testQueryAsSub() {
        let q = QUERY {
            SELECT { m.$name }
            FROM { m.table }
        }
        .asSubquery(MyModel.table)
        
        q.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"(SELECT "x"."name"::TEXT FROM "my_model" AS "x") AS "my_model""#)
    }
    
    func testQueryAsWith() {
        let q = QUERY {
            SELECT { m.$name }
            FROM { m.table }
        }
        .asWith(m.table)
        
        q.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #""x" AS (SELECT "x"."name"::TEXT FROM "my_model" AS "x")"#)
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
        
        q.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT "x"."name"::TEXT, "x"."title"::TEXT FROM "my_model" AS "x" GROUP BY "x"."name" ORDER BY "x"."name" DESC"#)
    }
    
    static var allTests = [
        ("testQuery", testQuery),
        ("testQueryAsSub", testQueryAsSub),
        ("testQueryAsWith", testQueryAsWith),
        ("testQueryN", testQueryN)
    ]
}
