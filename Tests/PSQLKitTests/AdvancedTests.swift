// AdvancedTests.swift
// Copyright (c) 2024 hiimtmac inc.

import PSQLKit
import SQLKit
import Testing

@Suite
struct AdvancedTests {
    @CTE("schema", schemaName: "space")
    struct TableSpace {
        var name: String
    }

    @CTE("date_range")
    struct DateRange {
        var date: PSQLDate
    }

    @Test
    func testSpaces() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT { TableSpace.$name }
            FROM { TableSpace.table }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "space"."schema"."name"::TEXT FROM "space"."schema""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSpacesAlias() {
        var serializer = SQLSerializer.test

        let p = TableSpace.as("a")

        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "a"."name"::TEXT FROM "space"."schema" AS "a""#
        #expect(serializer.sql == compare)
    }
}
