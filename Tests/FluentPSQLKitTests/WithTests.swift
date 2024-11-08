// WithTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct WithTests {
    let f = FluentModel.as("x")

    @Test
    func testWith1() {
        var serializer = SQLSerializer.test

        WITH {
            QUERY {
                SELECT { FluentModel.$name }
                FROM { FluentModel.table }
            }
            .asWith(FluentModel.table)
        }
        .serialize(to: &serializer)

        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testWith2() {
        var serializer = SQLSerializer.test

        WITH {
            QUERY {
                SELECT { f.$title }
                FROM { f.table }
            }
            .asWith(f.table)
        }
        .serialize(to: &serializer)

        let compare = #"WITH "x" AS (SELECT "x"."title"::TEXT FROM "my_model" AS "x")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testWithInQuery() {
        var serializer = SQLSerializer.test

        QUERY {
            WITH {
                QUERY {
                    SELECT { FluentModel.$name }
                    FROM { FluentModel.table }
                }
                .asWith(FluentModel.table)
            }
            SELECT { FluentModel.$name }
            FROM { FluentModel.table }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model") SELECT "my_model"."name"::TEXT FROM "my_model""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testWithErased() {
        var serializer = SQLSerializer.test

        let f = QUERY {
            SELECT { FluentModel.$name }
            FROM { FluentModel.table }
        }

        QUERY {
            WITH { f.asWith(FluentModel.table) }
            SELECT { FluentModel.$name }
            FROM { FluentModel.table }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model") SELECT "my_model"."name"::TEXT FROM "my_model""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test

        let bool = true
        WITH {
            if bool {
                QUERY { SELECT { f.$title } }.asWith(f.table)
            } else {
                QUERY { SELECT { f.$age } }.asWith(f.table)
            }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "x" AS (SELECT "x"."title"::TEXT)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test

        let bool = false
        WITH {
            if bool {
                QUERY { SELECT { f.$title } }.asWith(f.table)
            } else {
                QUERY { SELECT { f.$age } }.asWith(f.table)
            }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "x" AS (SELECT "x"."age"::INTEGER)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSwitch() {
        var serializer = SQLSerializer.test

        enum Test {
            case one
            case two
            case three
        }

        let option = Test.two

        WITH {
            switch option {
            case .one: QUERY { SELECT { f.$title } }.asWith(f.table)
            case .two: QUERY { SELECT { f.$age } }.asWith(f.table)
            case .three:
                QUERY { SELECT { f.$title } }.asWith(f.table)
                QUERY { SELECT { f.$age } }.asWith(f.table)
            }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "x" AS (SELECT "x"."age"::INTEGER)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfTrue() {
        var serializer = SQLSerializer.test

        let bool = true
        WITH {
            if bool {
                QUERY { SELECT { f.$title } }.asWith(f.table)
            }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "x" AS (SELECT "x"."title"::TEXT)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfFalse() {
        var serializer = SQLSerializer.test

        let bool = false
        WITH {
            if bool {
                QUERY { SELECT { f.$title } }.asWith(f.table)
            }
        }
        .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test

        WITH {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
