// GroupTests.swift
// Copyright © 2022 hiimtmac

import FluentKit
import XCTest
@testable import PSQLKit

final class GroupTests: PSQLTestCase {
    func testLength() {
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
        .serialize(to: &fluentSerializer)

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
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    static var allTests = [
        ("testLength", testLength),
    ]
}
