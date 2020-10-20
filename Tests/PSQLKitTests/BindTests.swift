import XCTest
@testable import PSQLKit
import FluentKit

final class BindTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testBindSimple() {
        let b = WHERE {
            m.$name == "tmac".asBind()
            m.$age > PSQLBind(8)
        }
        
        b.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."name" = $1) AND ("x"."age" > $2)"#)
        XCTAssertEqual(serializer.binds.first as! String, "tmac")
        XCTAssertEqual(serializer.binds.last as! Int, 8)
    }
    
    func testBindComplex() {
        let b = WHERE {
            m.$age >< (1.asBind()...PSQLBind(2))
            m.$age >< [PSQLBind(1), 2.asBind(), PSQLBind(3)]
        }
        
        b.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."age" BETWEEN $1 AND $2) AND ("x"."age" IN ($3, $4, $5))"#)
        XCTAssertEqual(serializer.binds[0] as! Int, 1)
        XCTAssertEqual(serializer.binds[1] as! Int, 2)
        XCTAssertEqual(serializer.binds[2] as! Int, 1)
        XCTAssertEqual(serializer.binds[3] as! Int, 2)
        XCTAssertEqual(serializer.binds[4] as! Int, 3)
    }
    
    static var allTests = [
        ("testBindSimple", testBindSimple),
        ("testBindComplex", testBindComplex),
    ]
}
