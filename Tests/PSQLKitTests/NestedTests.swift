// NestedTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
import PSQLKit

@Suite
struct NestedTests {
    let p = PSQLModel.as("x")

    @Test
    func testGroup() {
        var serializer = SQLSerializer.test

        SELECT {
            JSONB_EXTRACT_PATH_TEXT(p.$pet, \.$name)
            JSONB_EXTRACT_PATH_TEXT(p.$pet, \.$info, \.$name)
        }
        .serialize(to: &serializer)

        let compare = #"SELECT JSONB_EXTRACT_PATH_TEXT("x"."pet", 'name')::TEXT, JSONB_EXTRACT_PATH_TEXT("x"."pet", 'info', 'name')::TEXT"#
        #expect(serializer.sql == compare)
    }
}
