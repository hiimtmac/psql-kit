import XCTest
@testable import PSQLKit
import FluentKit

final class ExpressionTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testMax() {
        SELECT {
            MAX(f.$name)
            MAX(f.$age).as("age")
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            MAX(p.$name)
            MAX(p.$age).as("age")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT MAX("x"."name"::TEXT), MAX("x"."age"::INTEGER) AS "age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testMin() {
        SELECT {
            MIN(f.$name)
            MIN(f.$age).as("age")
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            MIN(p.$name)
            MIN(p.$age).as("age")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT MIN("x"."name"::TEXT), MIN("x"."age"::INTEGER) AS "age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testCount() {
        SELECT {
            COUNT(f.$name)
            COUNT(f.$age).as("age")
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            COUNT(p.$name)
            COUNT(p.$age).as("age")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT COUNT("x"."name"::TEXT), COUNT("x"."age"::INTEGER) AS "age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testSum() {
        SELECT {
            SUM(f.$name)
            SUM(f.$age).as("age")
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            SUM(p.$name)
            SUM(p.$age).as("age")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT SUM("x"."name"::TEXT), SUM("x"."age"::INTEGER) AS "age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testGenerateSeries() {
        let date1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!.psqlDate
        let date2 = DateComponents(calendar: .current, year: 2020, month: 01, day: 30).date!.psqlDate
        
        SELECT {
            GENERATE_SERIES(from: 8, to: 20, interval: 10)
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            GENERATE_SERIES(from: 8, to: 20, interval: 10)
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT GENERATE_SERIES(8::INTEGER, 20::INTEGER, 10::INTERVAL), GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL) AS "dates""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testConcat() {
        SELECT {
            CONCAT5(f.$name, " ", f.$title, " ", f.$age)
            CONCAT4(f.$name, " ", f.$title, " ").as("cool")
            CONCAT3(f.$name, " ", f.$title)
            CONCAT(8, 8).as("cool")
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            CONCAT5(p.$name, " ", p.$title, " ", p.$age)
            CONCAT4(p.$name, " ", p.$title, " ").as("cool")
            CONCAT3(p.$name, " ", p.$title)
            CONCAT(8, 8).as("cool")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT CONCAT("x"."name"::TEXT, ' '::TEXT, "x"."title"::TEXT, ' '::TEXT, "x"."age"::INTEGER), CONCAT("x"."name"::TEXT, ' '::TEXT, "x"."title"::TEXT, ' '::TEXT) AS "cool", CONCAT("x"."name"::TEXT, ' '::TEXT, "x"."title"::TEXT), CONCAT(8::INTEGER, 8::INTEGER) AS "cool""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testCoalesce() {
        SELECT {
            COALESCE5(f.$name, f.$name, f.$name, f.$name, "hello").as("cool")
            COALESCE4(f.$name, f.$name, f.$name, "hello").as("cool")
            COALESCE3(f.$name, f.$name, "hello").as("cool")
            COALESCE(f.$name, "hello").as("cool")
            COALESCE(f.$name, COALESCE(f.$name, "hello"))
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            COALESCE5(p.$name, p.$name, p.$name, p.$name, "hello").as("cool")
            COALESCE4(p.$name, p.$name, p.$name, "hello").as("cool")
            COALESCE3(p.$name, p.$name, "hello").as("cool")
            COALESCE(p.$name, "hello").as("cool")
            COALESCE(p.$name, COALESCE(f.$name, "hello"))
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT COALESCE("x"."name"::TEXT, "x"."name"::TEXT, "x"."name"::TEXT, "x"."name"::TEXT, 'hello'::TEXT) AS "cool", COALESCE("x"."name"::TEXT, "x"."name"::TEXT, "x"."name"::TEXT, 'hello'::TEXT) AS "cool", COALESCE("x"."name"::TEXT, "x"."name"::TEXT, 'hello'::TEXT) AS "cool", COALESCE("x"."name"::TEXT, 'hello'::TEXT) AS "cool", COALESCE("x"."name"::TEXT, COALESCE("x"."name"::TEXT, 'hello'::TEXT))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testJsonExtractPathText() {
        SELECT {
            JSONB_EXTRACT_PATH_TEXT(f.$pet, "hello").as("cool")
            JSONB_EXTRACT_PATH_TEXT(f.$pet, "hello", "cool")
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            JSONB_EXTRACT_PATH_TEXT(p.$pet, "hello").as("cool")
            JSONB_EXTRACT_PATH_TEXT(p.$pet, "hello", "cool")
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'hello') AS "cool", JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'hello', 'cool')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testNestedJsonExtract() {
        SELECT {
            COALESCE(
                JSONB_EXTRACT_PATH_TEXT(f.$pet, \.$name),
                JSONB_EXTRACT_PATH_TEXT(f.$pet, \.$type)
            )
        }
        .serialize(to: &fluentSerializer)
        
        SELECT {
            COALESCE(
                JSONB_EXTRACT_PATH_TEXT(p.$pet, \.$name),
                JSONB_EXTRACT_PATH_TEXT(p.$pet, \.$type)
            )
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT COALESCE(JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'name'), JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'type'))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testMax", testMax),
        ("testMin", testMin),
        ("testCount", testCount),
        ("testSum", testSum),
        ("testGenerateSeries", testGenerateSeries),
        ("testConcat", testConcat),
        ("testCoalesce", testCoalesce),
        ("testJsonExtractPathText", testJsonExtractPathText)
    ]
}
