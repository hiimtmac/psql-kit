import XCTest
@testable import PSQLKit
import FluentKit
import SQLKit

final class SQLExpressionTests: XCTestCase {
    struct Thing: Table {
        @OptionalColumn(key: "id") var id: UUID?
        @Column(key: "name") var name: String
    }
    
    func testExpressionRaw() {
        let q: some SQLExpression = QUERY {
            SELECT {
                Thing.$id
                Thing.$name
            }
            FROM { Thing.table }
        }
        
        let (sql, _) = q.raw()
        XCTAssertEqual(sql, #"SELECT "Thing"."id"::UUID, "Thing"."name"::TEXT FROM "Thing""#)
    }
    
    static var allTests = [
        ("testExpressionRaw", testExpressionRaw),
    ]
}
