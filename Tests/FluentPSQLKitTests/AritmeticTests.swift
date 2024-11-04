// AritmeticTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class ArithemticTests: PSQLTestCase {
    let f = FluentModel.as("x")

    func testSelect() {
        SELECT {
            f.$money / f.$money
            f.$money + f.$money
            (f.$money * f.$money).as("money")
        }
        .serialize(to: &fluentSerializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC + "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC * "x"."money"::NUMERIC)::NUMERIC AS "money""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testWhere() {
        WHERE {
            (f.$money / f.$money) > 4
        }
        .serialize(to: &fluentSerializer)

        let compare = #"WHERE (("x"."money" / "x"."money") > 4.0)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testTypeSwap() {
        SELECT {
            f.$money / f.$age.transform(to: Double.self)
        }
        .serialize(to: &fluentSerializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."age"::NUMERIC)::NUMERIC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testOptional() {
        let double: Double? = 8

        SELECT {
            f.$money / double
        }
        .serialize(to: &fluentSerializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / 8.0::NUMERIC)::NUMERIC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
