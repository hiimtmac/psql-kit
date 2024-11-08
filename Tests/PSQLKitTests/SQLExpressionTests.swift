// SQLExpressionTests.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import Testing
import PSQLKit

@Suite
struct SQLExpressionTests {
    @CTE("Thing")
    struct Thing {
        var id: UUID?
        var name: String
    }

    @Test
    func testExpressionRaw() {
        let q: some PSQLQuery = QUERY {
            SELECT {
                Thing.$id
                Thing.$name
            }
            FROM { Thing.table }
        }

        let (sql, _) = q.raw()
        #expect(sql == #"SELECT "Thing"."id"::UUID, "Thing"."name"::TEXT FROM "Thing""#)
    }
}
