import XCTest
@testable import PSQLKit
import FluentKit

final class NestedTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testGroup() {
        SELECT {
            JSONB_EXTRACT_PATH_TEXT(f.$pet, \.$name)
            JSONB_EXTRACT_PATH_TEXT(f.$pet, \.$info, \.$name)
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            JSONB_EXTRACT_PATH_TEXT(p.$pet, \.$name)
            JSONB_EXTRACT_PATH_TEXT(p.$pet, \.$info, \.$name)
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT JSONB_EXTRACT_PATH_TEXT("x"."pet", 'name')::TEXT, JSONB_EXTRACT_PATH_TEXT("x"."pet", 'info', 'name')::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testGroup", testGroup),
    ]
}
