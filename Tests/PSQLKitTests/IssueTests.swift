import XCTest
@testable import PSQLKit
import FluentKit

final class IssueTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testIssue6() {
        SELECT {
            f.$money / p.$money
            (f.$money / f.$money).as("money")
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            p.$money / p.$money
            (p.$money / p.$money).as("money")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC AS "money""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testIssue6", testIssue6)
    ]
}
