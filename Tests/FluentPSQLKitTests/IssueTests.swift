// IssueTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
import FluentKit
@testable import FluentPSQLKit

final class IssueTests: PSQLTestCase {
    let f = FluentModel.as("x")
    
    final class Test: CTE {
        static let tableName: String = "test"
        static let schemaName: String? = nil
        
        static let queryContainer = QueryContainer()
        struct QueryContainer {
            @ColumnAccessor<String>("test") var test: Never
        }
    }
    
    @FluentCTE("test")
    final class Test1: Model, @unchecked Sendable {        
        @ID
        var id: UUID?
        
        @Field(key: "test")
        var test: String
        
        init() {}
    }
    
    func testNew() {
        let a = Test.as("a")
        
        SELECT {
            Test.$test
            a.$test
            Test.$test.as("a")
            a.$test.as("a")
        }
        .serialize(to: &fluentSerializer)
        
        let compare = #"SELECT "test"."test"::TEXT, "a"."test"::TEXT, "test"."test"::TEXT AS "a", "a"."test"::TEXT AS "a""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
    
    func testNew1() {
        let a = Test1.as("a")
        
        SELECT {
            Test1.$test
            a.$test
            Test1.$test.as("a")
            a.$test.as("a")
        }
        .serialize(to: &fluentSerializer)
        
        let compare = #"SELECT "test"."test"::TEXT, "a"."test"::TEXT, "test"."test"::TEXT AS "a", "a"."test"::TEXT AS "a""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIssue6() {
        SELECT {
            f.$money / f.$money
            (f.$money / f.$money).as("money")
        }
        .serialize(to: &fluentSerializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC AS "money""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
