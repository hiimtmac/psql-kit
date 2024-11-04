// AritmeticTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class ArithemticTests: PSQLTestCase {
    let p = PSQLModel.as("x")

    func testSelect() {
        SELECT {
            p.$money / p.$money
            p.$money + p.$money
            (p.$money * p.$money).as("money")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC + "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC * "x"."money"::NUMERIC)::NUMERIC AS "money""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testWhere() {
        WHERE {
            (p.$money / p.$money) > 4
        }
        .serialize(to: &serializer)

        let compare = #"WHERE (("x"."money" / "x"."money") > 4.0)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testTypeSwap() {
        SELECT {
            p.$money / p.$age.transform(to: Double.self)
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."age"::NUMERIC)::NUMERIC"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testOptional() {
        let double: Double? = 8

        SELECT {
            p.$money / double
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / 8.0::NUMERIC)::NUMERIC"#
        XCTAssertEqual(serializer.sql, compare)
    }
}
