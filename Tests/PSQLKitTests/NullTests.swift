// NullTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
import PSQLKit

@Suite
struct NullTests {
    let p = PSQLModel.as("m")

    @Test
    func testNullEqual() {
        var serializer = SQLSerializer.test

        let val = nil as String?

        WHERE {
            p.$name == "hi"
            p.$name == "hi" as String?
            p.$name == val
            p.$name == String?.some("hi")
            p.$name == String?.none
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
            p.$name === "hi"
            p.$name === "hi" as String?
            p.$name === val
            p.$name === String?.some("hi")
            p.$name === String?.none
            p.$name === nil
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("m"."name" IS 'hi') AND ("m"."name" IS 'hi') AND ("m"."name" IS NULL) AND ("m"."name" IS 'hi') AND ("m"."name" IS NULL) AND ("m"."name" IS NULL)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testNullNotEqual() {
        var serializer = SQLSerializer.test

        let val = nil as String?

        WHERE {
            p.$name != "hi"
            p.$name != "hi" as String?
            p.$name != val
            p.$name != String?.some("hi")
            p.$name != String?.none
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
            p.$name !== "hi"
            p.$name !== "hi" as String?
            p.$name !== val
            p.$name !== String?.some("hi")
            p.$name !== String?.none
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("m"."name" IS NOT 'hi') AND ("m"."name" IS NOT 'hi') AND ("m"."name" IS NOT NULL) AND ("m"."name" IS NOT 'hi') AND ("m"."name" IS NOT NULL)"#
        #expect(serializer.sql == compare)
    }
}
