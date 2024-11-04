// IssueTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class IssueTests: PSQLTestCase {
    let f = FluentModel.as("x")

    func testIssue6() {
        SELECT {
            f.$money / f.$money
            (f.$money / f.$money).as("money")
        }
        .serialize(to: &fluentSerializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC AS "money""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
