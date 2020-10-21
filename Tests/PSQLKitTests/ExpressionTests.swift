import XCTest
@testable import PSQLKit
import FluentKit

final class ExpressionTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testMax() {
        let s = SELECT {
            MAX(m.$name)
            MAX(m.$age).as("age")
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT MAX("x"."name"::TEXT), MAX("x"."age"::INTEGER) AS "age""#)
    }

    func testMin() {
        let s = SELECT {
            MIN(m.$name)
            MIN(m.$age).as("age")
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT MIN("x"."name"::TEXT), MIN("x"."age"::INTEGER) AS "age""#)
    }
    
    func testCount() {
        let s = SELECT {
            COUNT(m.$name)
            COUNT(m.$age).as("age")
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT COUNT("x"."name"::TEXT), COUNT("x"."age"::INTEGER) AS "age""#)
    }
    
    func testSum() {
        let s = SELECT {
            SUM(m.$name)
            SUM(m.$age).as("age")
        }
        
        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT SUM("x"."name"::TEXT), SUM("x"."age"::INTEGER) AS "age""#)
    }
    
    func testGenerateSeries() {
        let date1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!.psqlDate
        let date2 = DateComponents(calendar: .current, year: 2020, month: 01, day: 30).date!.psqlDate
                
        let s = SELECT {
            GENERATE_SERIES(from: 8, to: 20, interval: 10)
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
        }

        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT GENERATE_SERIES(8::INTEGER, 20::INTEGER, 10::INTERVAL), GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL) AS "dates""#)
    }
    
    func testConcat() {
        let s = SELECT {
            CONCAT3(m.$name, " ", m.$title)
            CONCAT(8, 8).as("cool")
        }

        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT CONCAT("x"."name"::TEXT, ' '::TEXT, "x"."title"::TEXT), CONCAT(8::INTEGER, 8::INTEGER) AS "cool""#)
    }
    
    func testCoalesce() {
        let s = SELECT {
            COALESCE(m.$name, "hello").as("cool")
            COALESCE(m.$name, COALESCE(m.$name, "hello"))
        }

        s.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT COALESCE("x"."name"::TEXT, 'hello'::TEXT) AS "cool", COALESCE("x"."name"::TEXT, COALESCE("x"."name"::TEXT, 'hello'::TEXT))"#)
    }
    
    static var allTests = [
        ("testMax", testMax),
        ("testMin", testMin),
        ("testCount", testCount),
        ("testSum", testSum),
        ("testGenerateSeries", testGenerateSeries),
        ("testConcat", testConcat),
        ("testCoalesce", testCoalesce)
    ]
}
