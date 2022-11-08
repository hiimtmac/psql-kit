// IssueTests.swift
// Copyright © 2022 hiimtmac

import FluentKit
import XCTest
@testable import PSQLKit

final class IssueTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")

    func testIssue6() {
        SELECT {
            f.$money / p.$money
            (f.$money / f.$money).as("money")
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            p.$money / p.$money
            (p.$money / p.$money).as("money")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC AS "money""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
}
