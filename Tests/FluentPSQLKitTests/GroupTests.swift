// GroupTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct GroupTests {
    @Test
    func testLength() {
        var serializer = SQLSerializer.test
        SELECT {
            FluentModel.$id
            FluentModel.$age
            FluentModel.$name
            FluentModel.$id
            FluentModel.$age
            FluentModel.$name
            FluentModel.$id
            FluentModel.$age
            FluentModel.$id
            FluentModel.$age
            FluentModel.$name
            FluentModel.$id
            FluentModel.$age
            FluentModel.$name
            FluentModel.$id
            FluentModel.$age
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER"#
        #expect(serializer.sql == compare)
    }
}
