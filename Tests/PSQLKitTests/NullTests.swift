import XCTest
@testable import PSQLKit
import FluentKit

final class NullTests: PSQLTestCase {
    let f = FluentModel.as("m")
    let p = PSQLModel.as("m")
    
    func testNullEqual() {
        let val = nil as String?
        WHERE {
            f.$name == "hi"
            f.$name == "hi" as String?
            f.$name == val
            f.$name == Optional<String>.some("hi")
            f.$name == Optional<String>.none
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name == "hi"
            p.$name == "hi" as String?
            p.$name == val
            p.$name == Optional<String>.some("hi")
            p.$name == Optional<String>.none
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("m"."name" = 'hi') AND ("m"."name" = 'hi') AND ("m"."name" = NULL) AND ("m"."name" = 'hi') AND ("m"."name" = NULL)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testNullIs() {
        let val = nil as String?
        WHERE {
            f.$name === "hi"
            f.$name === "hi" as String?
            f.$name === val
            f.$name === Optional<String>.some("hi")
            f.$name === Optional<String>.none
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name === "hi"
            p.$name === "hi" as String?
            p.$name === val
            p.$name === Optional<String>.some("hi")
            p.$name === Optional<String>.none
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("m"."name" IS 'hi') AND ("m"."name" IS 'hi') AND ("m"."name" IS NULL) AND ("m"."name" IS 'hi') AND ("m"."name" IS NULL)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testNullNotEqual() {
        let val = nil as String?
        WHERE {
            f.$name != "hi"
            f.$name != "hi" as String?
            f.$name != val
            f.$name != Optional<String>.some("hi")
            f.$name != Optional<String>.none
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name != "hi"
            p.$name != "hi" as String?
            p.$name != val
            p.$name != Optional<String>.some("hi")
            p.$name != Optional<String>.none
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("m"."name" != 'hi') AND ("m"."name" != 'hi') AND ("m"."name" != NULL) AND ("m"."name" != 'hi') AND ("m"."name" != NULL)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testNullIsNot() {
        let val = nil as String?
        WHERE {
            f.$name !== "hi"
            f.$name !== "hi" as String?
            f.$name !== val
            f.$name !== Optional<String>.some("hi")
            f.$name !== Optional<String>.none
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name !== "hi"
            p.$name !== "hi" as String?
            p.$name !== val
            p.$name !== Optional<String>.some("hi")
            p.$name !== Optional<String>.none
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("m"."name" IS NOT 'hi') AND ("m"."name" IS NOT 'hi') AND ("m"."name" IS NOT NULL) AND ("m"."name" IS NOT 'hi') AND ("m"."name" IS NOT NULL)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testNullEqual", testNullEqual),
        ("testNullIs", testNullIs),
        ("testNullNotEqual", testNullNotEqual),
        ("testNullIsNot", testNullIsNot),
    ]
}
