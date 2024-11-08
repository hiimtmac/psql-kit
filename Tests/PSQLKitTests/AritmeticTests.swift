// AritmeticTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
import PSQLKit

@Suite
struct ArithemticTests {
    let p = PSQLModel.as("x")

    @Test
    func testSelect() {
        var serializer = SQLSerializer.test

        SELECT {
            p.$money / p.$money
            p.$money + p.$money
            (p.$money * p.$money).as("money")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC + "x"."money"::NUMERIC)::NUMERIC, ("x"."money"::NUMERIC * "x"."money"::NUMERIC)::NUMERIC AS "money""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testWhere() {
        var serializer = SQLSerializer.test

        WHERE {
            (p.$money / p.$money) > 4
        }
        .serialize(to: &serializer)

        let compare = #"WHERE (("x"."money" / "x"."money") > 4.0)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testTypeSwap() {
        var serializer = SQLSerializer.test

        SELECT {
            p.$money / p.$age.transform(to: Double.self)
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
            p.$money / double
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ("x"."money"::NUMERIC / 8.0::NUMERIC)::NUMERIC"#
        #expect(serializer.sql == compare)
    }
}
