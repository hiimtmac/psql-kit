import XCTest
@testable import PSQLKit
import FluentKit

final class NestedTests: PSQLTestCase {
    let m = FluentModel.as("x")
    
    func testGroup() {
        let s = SELECT {
            JSONB_EXTRACT_PATH_TEXT(m.$pet, \.$name)
            JSONB_EXTRACT_PATH_TEXT(m.$pet, \.$info, \.$name)
        }

        s.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"INNER JOIN "my_model" ON ("my_model"."name" = "my_model"."name")"#)
    }
    
    static var allTests = [
        ("testGroup", testGroup),
    ]
}
