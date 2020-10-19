import XCTest
@testable import ZZPSQLKit
import FluentKit

final class WithTests: PSQLTestCase {
    func testWith1() {
        let w = WITH {
            QUERY {
                SELECT { MyModel.$name }
                FROM { MyModel.table }
            }
            .asWith(MyModel.table)
        }
    
        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model")"#)
    }
    
    func testWith2() {
        let m = MyModel.as("x")
        let w = WITH {
            QUERY {
                SELECT { MyModel.$name }
                FROM { MyModel.table }
            }
            .asWith(MyModel.table)
            QUERY {
                SELECT { m.$title }
                FROM { m.table }
            }
            .asWith(m.table)
        }
        
        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model"), "x" AS (SELECT "x"."title"::TEXT FROM "my_model" AS "x")"#)
    }
    
    static var allTests = [
        ("testWith1", testWith1),
        ("testWith2", testWith2)
    ]
}
