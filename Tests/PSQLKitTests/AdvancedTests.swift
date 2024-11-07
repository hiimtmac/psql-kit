// AdvancedTests.swift
// Copyright (c) 2024 hiimtmac inc.

import PSQLKit
import XCTest

final class AdvancedTests: PSQLTestCase {
    @CTE("schema", schemaName: "space")
    struct TableSpace {
        var name: String
    }

    @CTE("date_range")
    struct DateRange {
        var date: PSQLDate
    }
    
    func testSpaces() {
        QUERY {
            SELECT { TableSpace.$name }
            FROM { TableSpace.table }
        }
        .serialize(to: &serializer)
        
        let compare = #"SELECT "space"."schema"."name"::TEXT FROM "space"."schema""#
        XCTAssertEqual(serializer.sql, compare)
    }
    
    func testSpacesAlias() {
        let p = TableSpace.as("a")
        
        QUERY {
            SELECT { p.$name }
            FROM { p.table }
        }
        .serialize(to: &serializer)
        
        let compare = #"SELECT "a"."name"::TEXT FROM "space"."schema" AS "a""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
