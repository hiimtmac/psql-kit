// QueryTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct QueryTests {
    let f = FluentModel.as("x")

    @Test
    func testQuery() {
        var serializer = SQLSerializer.test
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."name"::TEXT FROM "my_model" AS "x""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testQueryAsSub() {
        var serializer = SQLSerializer.test
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .asSubquery(FluentModel.table)
        .serialize(to: &serializer)

        let compare = #"(SELECT "x"."name"::TEXT FROM "my_model" AS "x") AS "my_model""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testQueryAsWith() {
        var serializer = SQLSerializer.test
        QUERY {
            SELECT { f.$name }
            FROM { f.table }
        }
        .asWith(self.f.table)
        .serialize(to: &serializer)

        let compare = #""x" AS (SELECT "x"."name"::TEXT FROM "my_model" AS "x")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testQueryN() {
        var serializer = SQLSerializer.test
        QUERY {
            SELECT {
                f.$name
                f.$title
            }
            FROM { f.table }
            GROUPBY { f.$name }
            ORDERBY { f.$name.desc() }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."name"::TEXT, "x"."title"::TEXT FROM "my_model" AS "x" GROUP BY "x"."name" ORDER BY "x"."name" DESC"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testUnion() {
        var serializer = SQLSerializer.test
        QUERY {
            UNION {
                QUERY { SELECT { f.$name } }
                QUERY { SELECT { f.$name } }
                QUERY { SELECT { f.$name } }
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."name"::TEXT UNION SELECT "x"."name"::TEXT UNION SELECT "x"."name"::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test
        let bool = true
        QUERY {
            if bool {
                SELECT { f.$name }
            } else {
                SELECT { f.$age }
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."name"::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test
        let bool = false
        QUERY {
            if bool {
                SELECT { f.$name }
            } else {
                SELECT { f.$age }
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."age"::INTEGER"#
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

        QUERY {
            switch option {
            case .one: SELECT { f.$name }
            case .two: SELECT { f.$age }
            case .three:
                SELECT { f.$name }
                FROM { f.table }
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."age"::INTEGER"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSelectSubquery() {
        var serializer = SQLSerializer.test
        SELECT {
            QUERY {
                SELECT { f.$age }
                FROM { f.table }
            }
            .asSubquery(f.table)
        }
        .serialize(to: &serializer)

        let compare = #"SELECT (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testReturning() {
        var serializer = SQLSerializer.test
        QUERY {
            UPDATE(f.table) {
                f.$name => "taylor"
            }
            WHERE { f.$name == "tmac" }
            RETURNING { f.$id }
        }
        .serialize(to: &serializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'taylor' WHERE ("x"."name" = 'tmac') RETURNING "x"."id"::UUID"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test
        QUERY {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
