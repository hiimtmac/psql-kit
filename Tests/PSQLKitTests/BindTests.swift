import XCTest
@testable import PSQLKit
import FluentKit

// needed because https://forums.swift.org/t/exported-import-does-not-properly-export-custom-operators/39090/5
infix operator ...: LogicalConjunctionPrecedence

final class BindTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testBindSimple() {
        WHERE {
            f.$name == "tmac".asBind()
            f.$age > PSQLBind(8)
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$name == "tmac".asBind()
            p.$age > PSQLBind(8)
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."name" = $1) AND ("x"."age" > $2)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
        XCTAssertEqual(fluentSerializer.binds.first as! String, "tmac")
        XCTAssertEqual(fluentSerializer.binds.last as! Int, 8)
    }
    
    func testBindComplex() {
        WHERE {
            f.$age >< (1.asBind()...PSQLBind(2))
            f.$age >< [PSQLBind(1), 2.asBind(), PSQLBind(3)]
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$age >< (1.asBind()...PSQLBind(2))
            p.$age >< [PSQLBind(1), 2.asBind(), PSQLBind(3)]
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."age" BETWEEN $1 AND $2) AND ("x"."age" IN ($3, $4, $5))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
        XCTAssertEqual(fluentSerializer.binds[0] as! Int, 1)
        XCTAssertEqual(fluentSerializer.binds[1] as! Int, 2)
        XCTAssertEqual(fluentSerializer.binds[2] as! Int, 1)
        XCTAssertEqual(fluentSerializer.binds[3] as! Int, 2)
        XCTAssertEqual(fluentSerializer.binds[4] as! Int, 3)
    }
    
    func testBindDate() {
        let date = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!
        
        WHERE {
            f.$birthday == date.psqlDate.asBind()
        }
        .serialize(to: &fluentSerializer)
        
        WHERE {
            p.$birthday == date.psqlDate.asBind()
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"WHERE ("x"."birthday" = $1)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
        XCTAssertEqual((fluentSerializer.binds[0] as! PSQLDate).storage, date)
    }
    
    static var allTests = [
        ("testBindSimple", testBindSimple),
        ("testBindComplex", testBindComplex),
    ]
}
