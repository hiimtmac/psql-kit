import XCTest
@testable import PSQLKit
import FluentKit

final class BindTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testBind() {
        let b = WHERE {
            m.$name == PSQLBind("tmac")
            m.$age > PSQLBind(8)
        }
        
        b.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("x"."name" = $1) AND ("x"."age" > $2)"#)
        XCTAssertEqual(serializer.binds.first as! String, "tmac")
        XCTAssertEqual(serializer.binds.last as! Int, 8)
    }
    
    static var allTests = [
        ("testBind", testBind),
    ]
}
