import XCTest
@testable import PSQLKit
import FluentKit

final class WithTests: PSQLTestCase {
    func testWith1() {
        let w = WITH {
            QUERY {
                SELECT { MyModel.$name }
                FROM { MyModel.table }
            }
            .asWith(MyModel.self)
        }
    
        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"WITH "my_model" AS (SELECT "my_model"."name"::text FROM "my_model")"#)
    }
    
    func testWith2() {
        let m = MyModel.as("x")
        let w = WITH {
            QUERY {
                SELECT { MyModel.$name }
                FROM { MyModel.table }
            }
            .asWith(MyModel.self)
            QUERY {
                SELECT { MyModel.$name }
                FROM { MyModel.table }
            }
            .asWith(m)
        }
        
        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"WITH "my_model" AS (SELECT "my_model"."name"::text FROM "my_model"), "x" AS (SELECT "my_model"."name"::text FROM "my_model")"#)
    }
    
    func testWithN() {

    }
    
    static var allTests = [
        ("testWith1", testWith1),
        ("testWith2", testWith2),
        ("testWithN", testWithN)
    ]
}
