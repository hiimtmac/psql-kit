import XCTest
@testable import ZZPSQLKit
import FluentKit

final class SelectTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testSelectModel() {
        let s = SELECT {
            MyModel.$name
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"SELECT "my_model"."name"::text"#)
    }
    
    func testSelectModelAlias() {
        let s = SELECT {
            m.$name
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"SELECT "x"."name"::text"#)
    }
    
    func testSelectBoth() {
        let s = SELECT {
            MyModel.$name
            m.$name
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"SELECT "my_model"."name"::text, "x"."name"::text"#)
    }
    
    func testSelectDistinctOn() {
        let s = SELECT {
            MyModel.$name
        }
        .distinctOn {
            m.$name
            m.$id
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"SELECT DISTINCT ON ("x"."name"::text, "x"."id"::uuid) "my_model"."name"::text"#)
    }
    
    func testSelectDistinct() {
        let s = SELECT {
            MyModel.$name
            m.$name
        }
        .distinct()
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"SELECT DISTINCT "my_model"."name"::text, "x"."name"::text"#)
    }
    
//    func testSelectAlias() {
//        let s = SELECT {
//            MyModel.$name
//                .as("nam")
//            m.$name
//                .as("nam")
//        }
//
//        s.serialize(to: &serializer)
//        XCTAssertEqual(serializer.psql, #"SELECT "my_model"."name"::text AS "nam", "x"."name"::text AS "nam""#)
//    }
    
    static var allTests = [
        ("testSelectModel", testSelectModel),
        ("testSelectModelAlias", testSelectModelAlias),
        ("testSelectBoth", testSelectBoth),
        ("testSelectDistinctOn", testSelectDistinctOn),
//        ("testSelectAlias", testSelectAlias)
    ]
}
