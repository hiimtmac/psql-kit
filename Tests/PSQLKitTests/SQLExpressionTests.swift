// SQLExpressionTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class SQLExpressionTests: XCTestCase {
    @CTE("Thing")
    struct Thing {
        var id: UUID?
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
