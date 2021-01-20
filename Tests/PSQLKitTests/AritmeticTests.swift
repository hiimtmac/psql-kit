import XCTest
@testable import PSQLKit
import FluentKit

final class ArithemticTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testSelect() {
        SELECT {
            f.$money / f.$money
            f.$money + f.$money
            (f.$money * f.$money).as("money")
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            p.$money / p.$money
            p.$money + p.$money
            (p.$money * p.$money).as("money")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC + "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC * "x"."money"::NUMERIC)::NUMERIC AS "money""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testWhere() {
        WHERE {
            (f.$money / f.$money) > 4
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            (p.$money / p.$money) > 4
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE (("x"."money" / "x"."money") > 4.0)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testTypeSwap() {
        SELECT {
            f.$money / f.$age.transform(to: Double.self)
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            p.$money / p.$age.transform(to: Double.self)
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."age"::NUMERIC)::NUMERIC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testOptional() {
        let double: Double? = 8
        
        SELECT {
            f.$money / double
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            p.$money / double
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT ("x"."money"::NUMERIC / 8.0)::NUMERIC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testSelect", testSelect),
        ("testWhere", testWhere),
        ("testTypeSwap", testTypeSwap),
        ("testOptional", testOptional)
    ]
}
