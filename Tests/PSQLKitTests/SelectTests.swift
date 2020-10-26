import XCTest
@testable import PSQLKit
import FluentKit

final class SelectTests: PSQLTestCase {
    let m = FluentModel.as("x")
    
    func testSelectModel() {
        let s = SELECT {
            FluentModel.$name
        }
        
        s.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT "my_model"."name"::TEXT"#)
    }
    
    func testSelectModelAlias() {
        let s = SELECT {
            m.$name
        }
        
        s.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT "x"."name"::TEXT"#)
    }
    
    func testSelectBoth() {
        let s = SELECT {
            FluentModel.$name
            m.$name
        }
        
        s.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT "my_model"."name"::TEXT, "x"."name"::TEXT"#)
    }
    
    func testSelectDistinctOn() {
        let s = SELECT {
            FluentModel.$name
        }
        .distinctOn {
            FluentModel.$name
            m.$id
        }
        
        s.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT DISTINCT ON ("my_model"."name"::TEXT, "x"."id"::UUID) "my_model"."name"::TEXT"#)
    }
    
    func testSelectDistinct() {
        let s = SELECT {
            FluentModel.$name
            m.$name
        }
        .distinct()
        
        s.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT DISTINCT "my_model"."name"::TEXT, "x"."name"::TEXT"#)
    }
    
    func testSelectAliasSingle() {
        let s = SELECT {
            FluentModel.$name
                .as("nam")
        }

        s.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT "my_model"."name"::TEXT AS "nam""#)
    }
    
    func testSelectAliasMultiple() {
        let s = SELECT {
            FluentModel.$name
                .as("nam")
            m.$name
                .as("nam")
            m.$id
        }

        s.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT "my_model"."name"::TEXT AS "nam", "x"."name"::TEXT AS "nam", "x"."id"::UUID"#)
    }
    
    func testSelectRaw() {
        let s = SELECT {
            RawColumn<String>("cool")
            RawColumn<String>("cool").as("yes")
            8.as("cool")
        }

        s.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT "cool"::TEXT, "cool"::TEXT AS "yes", 8::INTEGER AS "cool""#)
    }
    
    func testSelectSubquery() {
        let s = SELECT {
            QUERY {
                SELECT { m.$age }
                FROM { m.table }
            }
            .asSubquery(m.table)
        }
        
        s.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#)
    }
    
    func testPostfix() {
        let s = SELECT {
            FluentModel.table.*
            m.table.*
        }

        s.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT "my_model".*, "x".*"#)
    }
    
    static var allTests = [
        ("testSelectModel", testSelectModel),
        ("testSelectModelAlias", testSelectModelAlias),
        ("testSelectBoth", testSelectBoth),
        ("testSelectDistinctOn", testSelectDistinctOn),
        ("testSelectAliasSingle", testSelectAliasSingle),
        ("testSelectAliasMultiple", testSelectAliasMultiple),
        ("testSelectRaw", testSelectRaw),
        ("testSelectSubquery", testSelectSubquery),
        ("testPostfix", testPostfix)
    ]
}
