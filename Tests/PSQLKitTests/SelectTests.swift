import XCTest
@testable import PSQLKit
import FluentKit

final class SelectTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testSelectEmpty() {
        SELECT {}
        .serialize(to: &fluentSerializer)
        
        SELECT {}
        .serialize(to: &psqlkitSerializer)
        
        XCTAssertEqual(fluentSerializer.sql, #""#)
        XCTAssertEqual(psqlkitSerializer.sql, #""#)
    }
    
    func testSelectModel() {
        SELECT {
            FluentModel.$name
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            PSQLModel.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "my_model"."name"::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSelectModelAlias() {
        SELECT {
            f.$name
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            p.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "x"."name"::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSelectBoth() {
        SELECT {
            FluentModel.$name
            f.$name
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            PSQLModel.$name
            p.$name
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "my_model"."name"::TEXT, "x"."name"::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSelectDistinctOn() {
        SELECT {
            FluentModel.$name
        }
        .distinctOn {
            FluentModel.$name
            f.$id
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            PSQLModel.$name
        }
        .distinctOn {
            PSQLModel.$name
            p.$id
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT DISTINCT ON ("my_model"."name"::TEXT, "x"."id"::UUID) "my_model"."name"::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSelectDistinct() {
        SELECT {
            FluentModel.$name
            f.$name
        }
        .distinct()
        .serialize(to: &fluentSerializer)
        
        SELECT {
            PSQLModel.$name
            p.$name
        }
        .distinct()
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT DISTINCT "my_model"."name"::TEXT, "x"."name"::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSelectAliasSingle() {
        SELECT {
            FluentModel.$name.as("nam")
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            PSQLModel.$name.as("nam")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "my_model"."name"::TEXT AS "nam""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSelectAliasMultiple() {
        SELECT {
            FluentModel.$name.as("nam")
            f.$name.as("nam")
            f.$id
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            PSQLModel.$name.as("nam")
            p.$name.as("nam")
            p.$id
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "my_model"."name"::TEXT AS "nam", "x"."name"::TEXT AS "nam", "x"."id"::UUID"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSelectRaw() {
        let date = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!
        
        SELECT {
            RawColumn<String>("cool")
            RawColumn<String>("cool").as("yes")
            8
            8.as("cool")
            PSQLDate(date)
            RawValue(PSQLDate(date))
            date.psqlDate
            date.psqlDate.as("date_alias")
            RawValue(date.psqlDate).as("raw_date_alias")
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            RawColumn<String>("cool")
            RawColumn<String>("cool").as("yes")
            8
            8.as("cool")
            PSQLDate(date)
            RawValue(PSQLDate(date))
            date.psqlDate
            date.psqlDate.as("date_alias")
            RawValue(date.psqlDate).as("raw_date_alias")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "cool"::TEXT, "cool"::TEXT AS "yes", 8::INTEGER, 8::INTEGER AS "cool", '2020-01-01'::DATE, '2020-01-01'::DATE, '2020-01-01'::DATE, '2020-01-01'::DATE AS "date_alias", '2020-01-01'::DATE AS "raw_date_alias""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSelectSubquery() {
        SELECT {
            QUERY {
                SELECT { f.$age }
                FROM { f.table }
            }
            .asSubquery(f.table)
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            QUERY {
                SELECT { p.$age }
                FROM { p.table }
            }
            .asSubquery(p.table)
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testPostfix() {
        SELECT {
            FluentModel.table.*
            f.table.*
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            PSQLModel.table.*
            p.table.*
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "my_model".*, "x".*"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testIfTrue() {
        let bool = true
        SELECT {
            if bool {
                f.$name
            }
            f.$age
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            if bool {
                p.$name
            }
            p.$age
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "x"."name"::TEXT, "x"."age"::INTEGER"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testIfFalse() {
        let bool = false
        SELECT {
            if bool {
                f.$name
            }
            f.$age
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            if bool {
                p.$name
            }
            p.$age
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "x"."age"::INTEGER"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testIfElseTrue() {
        let bool = true
//        SELECT {
//            if true {
//                FluentModel.table.*
//            } else {
//                f.table.*
//            }
//        }
//        .serialize(to: &fluentSerializer)
        
        let ok = SELECT {
            if bool {
                PSQLModel.table.*
                p.table.*
            } else {
                PSQLModel.table.*
            }
            p.table.*
        }
//        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "my_model".*, "x".*"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testIfElseFalse() {
        let bool = false
//        SELECT {
//            if true {
//                FluentModel.table.*
//            } else {
//                f.table.*
//            }
//        }
//        .serialize(to: &fluentSerializer)
        
        let ok = SELECT {
            if bool {
                PSQLModel.table.*
                p.table.*
            } else {
                PSQLModel.table.*
            }
            p.table.*
        }
//        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "my_model".*, "x".*"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSwitch() {
        
    }
    
    static var allTests = [
        ("testSelectEmpty", testSelectEmpty),
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
