import XCTest
@testable import PSQLKit
import FluentKit

final class WithTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testWith1() {
        WITH {
            QUERY {
                SELECT { FluentModel.$name }
                FROM { FluentModel.table }
            }
            .asWith(FluentModel.table)
        }
        .serialize(to: &fluentSerializer)
        
        WITH {
            QUERY {
                SELECT { PSQLModel.$name }
                FROM { PSQLModel.table }
            }
            .asWith(FluentModel.table)
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testWith2() {
        WITH {
            QUERY {
                SELECT { f.$title }
                FROM { f.table }
            }
            .asWith(f.table)
        }
        .serialize(to: &fluentSerializer)
        
        WITH {
            QUERY {
                SELECT { p.$title }
                FROM { p.table }
            }
            .asWith(p.table)
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WITH "x" AS (SELECT "x"."title"::TEXT FROM "my_model" AS "x")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testWithInQuery() {
        QUERY {
            WITH {
                QUERY {
                    SELECT { FluentModel.$name }
                    FROM { FluentModel.table }
                }
                .asWith(FluentModel.table)
            }
            SELECT { FluentModel.$name }
            FROM { FluentModel.table }
        }
        .serialize(to: &fluentSerializer)
        
        QUERY {
            WITH {
                QUERY {
                    SELECT { PSQLModel.$name }
                    FROM { PSQLModel.table }
                }
                .asWith(PSQLModel.table)
            }
            SELECT { PSQLModel.$name }
            FROM { PSQLModel.table }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model") SELECT "my_model"."name"::TEXT FROM "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testWithErased() {
        let f: some PSQLQuery = QUERY {
            SELECT { FluentModel.$name }
            FROM { FluentModel.table }
        }
        
        QUERY {
            WITH { f.asWith(FluentModel.table) }
            SELECT { FluentModel.$name }
            FROM { FluentModel.table }
        }
        .serialize(to: &fluentSerializer)
        
        let p: some PSQLQuery = QUERY {
            SELECT { FluentModel.$name }
            FROM { FluentModel.table }
        }
        
        QUERY {
            WITH { p.asWith(FluentModel.table) }
            SELECT { FluentModel.$name }
            FROM { FluentModel.table }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model") SELECT "my_model"."name"::TEXT FROM "my_model""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testWith1", testWith1),
        ("testWith2", testWith2),
        ("testWithErased", testWithErased)
    ]
}
