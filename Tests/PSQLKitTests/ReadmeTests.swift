import XCTest
import PSQLKit
import FluentKit
import FluentBenchmark

final class ReadmeTests: PSQLTestCase {
    func testExample() {
        
        
        XCTAssertEqual(serializer.sql, "")
    }
    
    static var allTests = [
        ("testExample", testExample)
    ]
}

extension Galaxy: Table {}
    
extension Moon: Table {}
    
extension Planet: Table {}
    
extension PlanetTag: Table {}
    
extension Star: Table {}
    
extension Tag: Table {}
