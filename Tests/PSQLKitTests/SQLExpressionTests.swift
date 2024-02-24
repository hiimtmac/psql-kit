// SQLExpressionTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class SQLExpressionTests: XCTestCase {
    struct Thing: Table {
        @OptionalColumn(key: "id")
        var id: UUID?
        @Column(key: "name")
        var name: String
    }

    func testExpressionRaw() {
        let q: some PSQLQuery = QUERY {
            SELECT {
                Thing.$id
                Thing.$name
            }
            FROM { Thing.table }
        }

        let (sql, _) = q.raw()
        XCTAssertEqual(sql, #"SELECT "Thing"."id"::UUID, "Thing"."name"::TEXT FROM "Thing""#)
    }
}
