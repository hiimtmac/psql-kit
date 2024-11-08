// NullTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct NullTests {
    let f = FluentModel.as("m")

    @Test
    func testNullEqual() {
        var serializer = SQLSerializer.test
        let val = nil as String?
        WHERE {
            f.$name == "hi"
            f.$name == "hi" as String?
            f.$name == val
            f.$name == String?.some("hi")
            f.$name == String?.none
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("m"."name" = 'hi') AND ("m"."name" = 'hi') AND ("m"."name" = NULL) AND ("m"."name" = 'hi') AND ("m"."name" = NULL)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testNullIs() {
        var serializer = SQLSerializer.test
        let val = nil as String?
        WHERE {
            f.$name === "hi"
            f.$name === "hi" as String?
            f.$name === val
            f.$name === String?.some("hi")
            f.$name === String?.none
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("m"."name" IS 'hi') AND ("m"."name" IS 'hi') AND ("m"."name" IS NULL) AND ("m"."name" IS 'hi') AND ("m"."name" IS NULL)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testNullNotEqual() {
        var serializer = SQLSerializer.test
        let val = nil as String?
        WHERE {
            f.$name != "hi"
            f.$name != "hi" as String?
            f.$name != val
            f.$name != String?.some("hi")
            f.$name != String?.none
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("m"."name" != 'hi') AND ("m"."name" != 'hi') AND ("m"."name" != NULL) AND ("m"."name" != 'hi') AND ("m"."name" != NULL)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testNullIsNot() {
        var serializer = SQLSerializer.test
        let val = nil as String?
        WHERE {
            f.$name !== "hi"
            f.$name !== "hi" as String?
            f.$name !== val
            f.$name !== String?.some("hi")
            f.$name !== String?.none
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("m"."name" IS NOT 'hi') AND ("m"."name" IS NOT 'hi') AND ("m"."name" IS NOT NULL) AND ("m"."name" IS NOT 'hi') AND ("m"."name" IS NOT NULL)"#
        #expect(serializer.sql == compare)
    }
}
