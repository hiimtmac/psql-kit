import XCTest
@testable import PSQLKit
import FluentKit

final class NullTests: PSQLTestCase {
    let m = MyModel.as("m")
    
    func testNullEqual() {
        let val = nil as String?
        let j = WHERE {
            m.$name == "hi"
            m.$name == "hi" as String?
            m.$name == val
            m.$name == Optional<String>.some("hi")
            m.$name == Optional<String>.none
        }

        j.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("m"."name" = 'hi') AND ("m"."name" = 'hi') AND ("m"."name" = NULL) AND ("m"."name" = 'hi') AND ("m"."name" = NULL)"#)
    }
    
    func testNullIs() {
        let val = nil as String?
        let j = WHERE {
            m.$name === "hi"
            m.$name === "hi" as String?
            m.$name === val
            m.$name === Optional<String>.some("hi")
            m.$name === Optional<String>.none
        }

        j.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("m"."name" IS 'hi') AND ("m"."name" IS 'hi') AND ("m"."name" IS NULL) AND ("m"."name" IS 'hi') AND ("m"."name" IS NULL)"#)
    }
    
    func testNullNotEqual() {
        let val = nil as String?
        let j = WHERE {
            m.$name != "hi"
            m.$name != "hi" as String?
            m.$name != val
            m.$name != Optional<String>.some("hi")
            m.$name != Optional<String>.none
        }

        j.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("m"."name" != 'hi') AND ("m"."name" != 'hi') AND ("m"."name" != NULL) AND ("m"."name" != 'hi') AND ("m"."name" != NULL)"#)
    }
    
    func testNullIsNot() {
        let val = nil as String?
        let j = WHERE {
            m.$name !== "hi"
            m.$name !== "hi" as String?
            m.$name !== val
            m.$name !== Optional<String>.some("hi")
            m.$name !== Optional<String>.none
        }

        j.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("m"."name" IS NOT 'hi') AND ("m"."name" IS NOT 'hi') AND ("m"."name" IS NOT NULL) AND ("m"."name" IS NOT 'hi') AND ("m"."name" IS NOT NULL)"#)
    }
    
    static var allTests = [
        ("testNullEqual", testNullEqual),
        ("testNullNotEqual", testNullNotEqual),
    ]
}
