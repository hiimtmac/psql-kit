// NestedTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct NestedTests {
    let f = FluentModel.as("x")

    @Test
    func testGroup() {
        var serializer = SQLSerializer.test
        SELECT {
            JSONB_EXTRACT_PATH_TEXT(f.$pet, \.$name)
            JSONB_EXTRACT_PATH_TEXT(f.$pet, \.$info, \.$name)
        }
        .serialize(to: &serializer)

        let compare = #"SELECT JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'name')::TEXT, JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'info', 'name')::TEXT"#
        #expect(serializer.sql == compare)
    }
}
