// NestedTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import FluentPSQLKit

final class NestedTests: PSQLTestCase {
    let f = FluentModel.as("x")

    func testGroup() {
        SELECT {
            JSONB_EXTRACT_PATH_TEXT(f.$pet, \.$name)
            JSONB_EXTRACT_PATH_TEXT(f.$pet, \.$info, \.$name)
        }
        .serialize(to: &fluentSerializer)

        let compare = #"SELECT JSONB_EXTRACT_PATH_TEXT("x"."pet", 'name')::TEXT, JSONB_EXTRACT_PATH_TEXT("x"."pet", 'info', 'name')::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
