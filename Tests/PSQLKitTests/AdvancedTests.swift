// AdvancedTests.swift
// Copyright (c) 2024 hiimtmac inc.

import PSQLKit
import XCTest

final class AdvancedTests: PSQLTestCase {
    struct TableSpace: Table, @unchecked Sendable {
        static let schema: String = "schema"
        static let path: String? = "space"
        @Column(key: "name")
        var name: String
    }

    struct DateRange: Table, @unchecked Sendable {
        static let schema: String = "date_range"
        @Column(key: "date")
        var date: PSQLDate
    }

    struct OwnerFilter: Table, @unchecked Sendable {
        @Column(key: "id")
        var id: UUID
    }

    struct OwnerDateSeries: Table, @unchecked Sendable {
        @OptionalColumn(key: "id")
        var id: UUID?
        @Column(key: "date")
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
