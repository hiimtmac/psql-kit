// IssueTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
import PSQLKit

@Suite
struct IssueTests {
    let p = PSQLModel.as("x")

    struct Test: Table {
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

    @Test
    func testNew() {
        var serializer = SQLSerializer.test

        let a = Test.as("a")

        SELECT {
            Test.$test
            a.$test
            Test.$test.as("a")
            a.$test.as("a")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "test"."test"::TEXT, "a"."test"::TEXT, "test"."test"::TEXT AS "a", "a"."test"::TEXT AS "a""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testNew1() {
        var serializer = SQLSerializer.test

        let a = Test1.as("a")

        SELECT {
            Test1.$test
            a.$test
            Test1.$test.as("a")
            a.$test.as("a")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "test"."test"::TEXT, "a"."test"::TEXT, "test"."test"::TEXT AS "a", "a"."test"::TEXT AS "a""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIssue6() {
        var serializer = SQLSerializer.test

        SELECT {
            p.$money / p.$money
            (p.$money / p.$money).as("money")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC AS "money""#
        #expect(serializer.sql == compare)
    }
    
    @Test
    func testEmptyIn() {
        var serializer = SQLSerializer.test
        
        WHERE {
            p.$name >< [String]()
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" IN (NULL))"#
        #expect(serializer.sql == compare)
    }
}
