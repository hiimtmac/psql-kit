// BindTests.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import SQLKit
import Testing
@testable import FluentPSQLKit

// needed because https://forums.swift.org/t/exported-import-does-not-properly-export-custom-operators/39090/5
infix operator ...: LogicalConjunctionPrecedence

@Suite
struct BindTests {
    let f = FluentModel.as("x")

    @Test
    func testBindSimple() {
        var serializer = SQLSerializer.test
        WHERE {
            f.$name == "tmac".asBind()
            f.$age > PSQLBind(8)
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" = $1) AND ("x"."age" > $2)"#
        #expect(serializer.sql == compare)
        #expect(serializer.binds.first as! String == "tmac")
        #expect(serializer.binds.last as! Int == 8)
    }

    @Test
    func testBindComplex() {
        var serializer = SQLSerializer.test
        WHERE {
            f.$age >< (1.asBind() ... PSQLBind(2))
            f.$age >< [PSQLBind(1), 2.asBind(), PSQLBind(3)]
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."age" BETWEEN $1 AND $2) AND ("x"."age" IN ($3, $4, $5))"#
        #expect(serializer.sql == compare)
        #expect(serializer.binds[0] as! Int == 1)
        #expect(serializer.binds[1] as! Int == 2)
        #expect(serializer.binds[2] as! Int == 1)
        #expect(serializer.binds[3] as! Int == 2)
        #expect(serializer.binds[4] as! Int == 3)
    }

    @Test
    func testBindDate() {
        var serializer = SQLSerializer.test
        let date = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!

        WHERE {
            f.$birthday == date.psqlDate.asBind()
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."birthday" = $1)"#
        #expect(serializer.sql == compare)
        #expect((serializer.binds[0] as! PSQLDate).storage == date)
    }

    @Test
    func testDateBindCodable() throws {
        let swift = DateComponents(calendar: .current, timeZone: TimeZone(identifier: "UTC"), year: 2020, month: 01, day: 01, hour: 01, minute: 01, second: 01).date!

        let date = PSQLDate(swift)
        let timestamp = PSQLTimestamp(swift)

        let encodeDate = try JSONEncoder().encode(date)
        #expect(String(decoding: encodeDate, as: UTF8.self) == "599533261")
        let encodeTimestamp = try JSONEncoder().encode(timestamp)
        #expect(String(decoding: encodeTimestamp, as: UTF8.self) == "599533261")

        let decodeDate = try JSONDecoder().decode(PSQLDate.self, from: encodeDate)
        #expect("\(decodeDate.storage)" == "2020-01-01 00:00:00 +0000")
        let decodeTimestamp = try JSONDecoder().decode(PSQLTimestamp.self, from: encodeTimestamp)
        #expect("\(decodeTimestamp.storage)" == "2020-01-01 01:01:00 +0000")
    }

    @Test
    func testBindArray() throws {
        var serializer = SQLSerializer.test
        WHERE {
            f.$name >< ["tmac", "taylor"].map { $0.asBind() }
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" IN ($1, $2))"#
        #expect(serializer.sql == compare)
    }
}
