// GroupTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
import PSQLKit

@Suite
struct GroupTests {
    @Test
    func testLength() {
        var serializer = SQLSerializer.test

        SELECT {
            PSQLModel.$id
            PSQLModel.$age
            PSQLModel.$name
            PSQLModel.$id
            PSQLModel.$age
            PSQLModel.$name
            PSQLModel.$id
            PSQLModel.$age
            PSQLModel.$id
            PSQLModel.$age
            PSQLModel.$name
            PSQLModel.$id
            PSQLModel.$age
            PSQLModel.$name
            PSQLModel.$id
            PSQLModel.$age
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER"#
        #expect(serializer.sql == compare)
    }
}
