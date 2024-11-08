// AritmeticTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct ArithemticTests {
    let f = FluentModel.as("x")

    @Test
    func testSelect() {
        var serializer = SQLSerializer.test
        SELECT {
            f.$money / f.$money
            f.$money + f.$money
            (f.$money * f.$money).as("money")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC + "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC * "x"."money"::NUMERIC)::NUMERIC AS "money""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testWhere() {
        var serializer = SQLSerializer.test
        WHERE {
            (f.$money / f.$money) > 4
        }
        .serialize(to: &serializer)

        let compare = #"WHERE (("x"."money" / "x"."money") > 4.0)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testTypeSwap() {
        var serializer = SQLSerializer.test
        SELECT {
            f.$money / f.$age.transform(to: Double.self)
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."age"::NUMERIC)::NUMERIC"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testOptional() {
        var serializer = SQLSerializer.test
        let double: Double? = 8

        SELECT {
            f.$money / double
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / 8.0::NUMERIC)::NUMERIC"#
        #expect(serializer.sql == compare)
    }
}
