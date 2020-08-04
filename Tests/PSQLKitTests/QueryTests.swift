import XCTest
@testable import PSQLKit
import FluentKit

final class QueryTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testQuery() {
        let q = QUERY {
            SELECT { m.$name }
            FROM { m.table }
        }
        
        q.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"SELECT "x"."name"::text FROM "my_model" AS "x""#)
    }
    
    func testQueryAsSub() {
        let q = QUERY {
            SELECT { m.$name }
            FROM { m.table }
        }
        .asSub(MyModel.self)
        
        q.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"(SELECT "x"."name"::text FROM "my_model" AS "x") AS "my_model""#)
    }
    
    func testQueryAsWith() {
        let q = QUERY {
            SELECT { m.$name }
            FROM { m.table }
        }
        .asWith(MyModel.self)
        
        q.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #""my_model" AS (SELECT "x"."name"::text FROM "my_model" AS "x")"#)
    }
    
    func testQueryN() {
        let q = QUERY {
            WITH {
                QUERY {
                    SELECT { m.$name }
                    FROM { m.table }
                }
                .asWith("with")
            }
            
            SELECT {
                m.$name
                m.$name
            }
            FROM { m.table }
            GROUPBY { m.$name }
            ORDERBY { m.$name }
        }
        
        q.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"WITH "with" AS (SELECT "x"."name"::text FROM "my_model" AS "x") SELECT "x"."name"::text, "x"."name"::text FROM "my_model" AS "x" GROUP BY "x"."name" ORDER BY "x"."name" ASC"#)
    }
    
    static var allTests = [
        ("testQuery", testQuery),
        ("testQueryAsSub", testQueryAsSub),
        ("testQueryAsWith", testQueryAsWith),
        ("testQueryN", testQueryN)
    ]
}
