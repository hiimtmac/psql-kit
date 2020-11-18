import XCTest
@testable import PSQLKit
import FluentKit

final class QueryTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testEmpty() {
        QUERY {}
        .serialize(to: &fluentSerializer)
        
        QUERY {}
        .serialize(to: &psqlkitSerializer)
        
        XCTAssertEqual(fluentSerializer.sql, #""#)
        XCTAssertEqual(psqlkitSerializer.sql, #""#)
    }
    
    func testQuery() {
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .serialize(to: &fluentSerializer)
        
        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "x"."name"::TEXT FROM "my_model" AS "x""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testQueryAsSub() {
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .asSubquery(FluentModel.table)
        .serialize(to: &fluentSerializer)
        
        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .asSubquery(PSQLModel.table)
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"(SELECT "x"."name"::TEXT FROM "my_model" AS "x") AS "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testQueryAsWith() {
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .asWith(f.table)
        .serialize(to: &fluentSerializer)
        
        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .asWith(p.table)
        .serialize(to: &psqlkitSerializer)
        
        let compare = #""x" AS (SELECT "x"."name"::TEXT FROM "my_model" AS "x")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testQueryN() {
        QUERY {
            SELECT {
                f.$name
                f.$title
            }
            FROM { f.table }
            GROUPBY { f.$name }
            ORDERBY { f.$name.desc() }
        }
        .serialize(to: &fluentSerializer)
        
        QUERY {
            SELECT {
                p.$name
                p.$title
            }
            FROM { p.table }
            GROUPBY { p.$name }
            ORDERBY { p.$name.desc() }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "x"."name"::TEXT, "x"."title"::TEXT FROM "my_model" AS "x" GROUP BY "x"."name" ORDER BY "x"."name" DESC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testUnion() {
        QUERY {
            UNION {
                QUERY { SELECT { f.$name } }
                QUERY { SELECT { f.$name } }
                QUERY { SELECT { f.$name } }
            }
        }
        .serialize(to: &fluentSerializer)
        
        QUERY {
            UNION {
                QUERY { SELECT { p.$name } }
                QUERY { SELECT { p.$name } }
                QUERY { SELECT { p.$name } }
            }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "x"."name"::TEXT UNION SELECT "x"."name"::TEXT UNION SELECT "x"."name"::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testEmpty", testEmpty),
        ("testQuery", testQuery),
        ("testQueryAsSub", testQueryAsSub),
        ("testQueryAsWith", testQueryAsWith),
        ("testQueryN", testQueryN),
        ("testUnion", testUnion)
    ]
}
