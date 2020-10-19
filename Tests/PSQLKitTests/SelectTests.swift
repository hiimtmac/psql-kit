import XCTest
@testable import PSQLKit
import FluentKit

final class SelectTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testSelectModel() {
        let s = SELECT {
            MyModel.$name
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT "my_model"."name"::TEXT"#)
    }
    
    func testSelectModelAlias() {
        let s = SELECT {
            m.$name
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT "x"."name"::TEXT"#)
    }
    
    func testSelectBoth() {
        let s = SELECT {
            MyModel.$name
            m.$name
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT "my_model"."name"::TEXT, "x"."name"::TEXT"#)
    }
    
    func testSelectDistinctOn() {
        let s = SELECT {
            MyModel.$name
        }
        .distinctOn {
            MyModel.$name
            m.$id
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT DISTINCT ON ("my_model"."name"::TEXT, "x"."id"::UUID) "my_model"."name"::TEXT"#)
    }
    
    func testSelectDistinct() {
        let s = SELECT {
            MyModel.$name
            m.$name
        }
        .distinct()
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT DISTINCT "my_model"."name"::TEXT, "x"."name"::TEXT"#)
    }
    
    func testSelectAliasSingle() {
        let s = SELECT {
            MyModel.$name
                .as("nam")
        }

        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT "my_model"."name"::TEXT AS "nam""#)
    }
    
    func testSelectAliasMultiple() {
        let s = SELECT {
            MyModel.$name
                .as("nam")
            m.$name
                .as("nam")
            m.$id
        }

        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT "my_model"."name"::TEXT AS "nam", "x"."name"::TEXT AS "nam", "x"."id"::UUID"#)
    }
    
    func testSelectRaw() {
        let s = SELECT {
            RawColumn<String>("cool")
        }

        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT "cool"::TEXT"#)
    }
    
    static var allTests = [
        ("testSelectModel", testSelectModel),
        ("testSelectModelAlias", testSelectModelAlias),
        ("testSelectBoth", testSelectBoth),
        ("testSelectDistinctOn", testSelectDistinctOn),
        ("testSelectAliasSingle", testSelectAliasSingle),
        ("testSelectAliasMultiple", testSelectAliasMultiple),
        ("testSelectRaw", testSelectRaw)
    ]
}
