// IssueTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class IssueTests: PSQLTestCase {
    let p = PSQLModel.as("x")
    
    struct Test: CTE {
        static let tableName: String = "test"
        static let schemaName: String? = nil
        
        static let queryContainer = QueryContainer()
        struct QueryContainer {
            @ColumnAccessor<String>("test") var test: Never
        }
    }
    
    @CTE("test")
    struct Test1 {
        var test: String
    }
    
    func testNew() {
        let a = Test.as("a")
        
        SELECT {
            Test.$test
            a.$test
            Test.$test.as("a")
            a.$test.as("a")
        }
        .serialize(to: &serializer)
        
        let compare = #"SELECT "test"."test"::TEXT, "a"."test"::TEXT, "test"."test"::TEXT AS "a", "a"."test"::TEXT AS "a""#
        XCTAssertEqual(serializer.sql, compare)
    }
    
    func testNew1() {
        let a = Test1.as("a")
        
        SELECT {
            Test1.$test
            a.$test
            Test1.$test.as("a")
            a.$test.as("a")
        }
        .serialize(to: &serializer)
        
        let compare = #"SELECT "test"."test"::TEXT, "a"."test"::TEXT, "test"."test"::TEXT AS "a", "a"."test"::TEXT AS "a""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIssue6() {
        SELECT {
            p.$money / p.$money
            (p.$money / p.$money).as("money")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC AS "money""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
