// WithTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
import PSQLKit

@Suite
struct WithTests {
    let p = PSQLModel.as("x")

    @Test
    func testWith1() {
        var serializer = SQLSerializer.test

        WITH {
            QUERY {
                SELECT { PSQLModel.$name }
                FROM { PSQLModel.table }
            }
            .asWith(PSQLModel.table)
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
                SELECT { p.$title }
                FROM { p.table }
            }
            .asWith(p.table)
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
                    SELECT { PSQLModel.$name }
                    FROM { PSQLModel.table }
                }
                .asWith(PSQLModel.table)
            }
            SELECT { PSQLModel.$name }
            FROM { PSQLModel.table }
        }
        .serialize(to: &serializer)

        let compare = #"WITH "my_model" AS (SELECT "my_model"."name"::TEXT FROM "my_model") SELECT "my_model"."name"::TEXT FROM "my_model""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testWithErased() {
        var serializer = SQLSerializer.test

        let p = QUERY {
            SELECT { PSQLModel.$name }
            FROM { PSQLModel.table }
        }

        QUERY {
            WITH { p.asWith(PSQLModel.table) }
            SELECT { PSQLModel.$name }
            FROM { PSQLModel.table }
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
                QUERY { SELECT { p.$title } }.asWith(p.table)
            } else {
                QUERY { SELECT { p.$age } }.asWith(p.table)
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
                QUERY { SELECT { p.$title } }.asWith(p.table)
            } else {
                QUERY { SELECT { p.$age } }.asWith(p.table)
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
            case .one: QUERY { SELECT { p.$title } }.asWith(p.table)
            case .two: QUERY { SELECT { p.$age } }.asWith(p.table)
            case .three:
                QUERY { SELECT { p.$title } }.asWith(p.table)
                QUERY { SELECT { p.$age } }.asWith(p.table)
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
                QUERY { SELECT { p.$title } }.asWith(p.table)
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
                QUERY { SELECT { p.$title } }.asWith(p.table)
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
