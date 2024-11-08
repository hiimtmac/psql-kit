// QueryTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
import PSQLKit

@Suite
struct QueryTests {
    let p = PSQLModel.as("x")

    @Test
    func testQuery() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."name"::TEXT FROM "my_model" AS "x""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testQueryAsSub() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .asSubquery(PSQLModel.table)
        .serialize(to: &serializer)

        let compare = #"(SELECT "x"."name"::TEXT FROM "my_model" AS "x") AS "my_model""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testQueryAsWith() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .asWith(self.p.table)
        .serialize(to: &serializer)

        let compare = #""x" AS (SELECT "x"."name"::TEXT FROM "my_model" AS "x")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testQueryN() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT {
                p.$name
                p.$title
            }
            FROM { p.table }
            GROUPBY { p.$name }
            ORDERBY { p.$name.desc() }
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
                QUERY { SELECT { p.$name } }
                QUERY { SELECT { p.$name } }
                QUERY { SELECT { p.$name } }
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
                SELECT { p.$name }
            } else {
                SELECT { p.$age }
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
                SELECT { p.$name }
            } else {
                SELECT { p.$age }
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
            case .one: SELECT { p.$name }
            case .two: SELECT { p.$age }
            case .three:
                SELECT { p.$name }
                FROM { p.table }
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
                SELECT { p.$age }
                FROM { p.table }
            }
            .asSubquery(p.table)
        }
        .serialize(to: &serializer)

        let compare = #"SELECT (SELECT "x"."age"::INTEGER FROM "my_model" AS "x") AS "x""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testReturning() {
        var serializer = SQLSerializer.test

        QUERY {
            UPDATE(p.table) {
                p.$name => "taylor"
            }
            WHERE { p.$name == "tmac" }
            RETURNING { p.$id }
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
