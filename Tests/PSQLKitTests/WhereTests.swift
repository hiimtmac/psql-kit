// WhereTests.swift
// Copyright © 2022 hiimtmac

import FluentKit
import XCTest
@testable import PSQLKit

// needed because https://forums.swift.org/t/exported-import-does-not-properly-export-custom-operators/39090/5
infix operator ~~: ComparisonPrecedence
infix operator ...: LogicalConjunctionPrecedence

final class WhereTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")

    func testEqual() {
        WHERE {
            FluentModel.$name == FluentModel.$title
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            PSQLModel.$name == PSQLModel.$title
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("my_model"."name" = "my_model"."title")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testMultiple() {
        WHERE {
            FluentModel.$name == f.$title
            f.$name != FluentModel.$title
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            PSQLModel.$name == p.$title
            p.$name != PSQLModel.$title
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("my_model"."name" = "x"."title") AND ("x"."name" != "my_model"."title")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testNotEqual() {
        WHERE {
            f.$name != f.$title
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$name != p.$title
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."name" != "x"."title")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIn() {
        WHERE {
            f.$name <> ["name", "hi"]
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$name <> ["name", "hi"]
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."name" NOT IN ('name', 'hi'))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testNotIn() {
        WHERE {
            f.$name >< ["name", "hi"]
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$name >< ["name", "hi"]
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."name" IN ('name', 'hi'))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testBetween() {
        WHERE {
            f.$age >< (20 ... 30)
            f.$age >< ((f.$age) ... (f.$age))
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$age >< (20 ... 30)
            p.$age >< ((p.$age) ... (p.$age))
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."age" BETWEEN 20 AND 30) AND ("x"."age" BETWEEN "x"."age" AND "x"."age")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testNotBetween() {
        WHERE {
            f.$age <> (20 ... 30)
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$age <> (20 ... 30)
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."age" NOT BETWEEN 20 AND 30)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testLiteral() {
        WHERE {
            f.$name == "hello"
            f.$name != "hello"
            f.$age < 29
            f.$age <= 29
            f.$age > 29
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$name == "hello"
            p.$name != "hello"
            p.$age < 29
            p.$age <= 29
            p.$age > 29
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."name" = 'hello') AND ("x"."name" != 'hello') AND ("x"."age" < 29) AND ("x"."age" <= 29) AND ("x"."age" > 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testWhereOr() {
        WHERE {
            f.$name <> ["name", "hi"] || FluentModel.$name != FluentModel.$name
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$name <> ["name", "hi"] || PSQLModel.$name != PSQLModel.$name
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE (("x"."name" NOT IN ('name', 'hi')) OR ("my_model"."name" != "my_model"."name"))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testWhereRaw() {
        WHERE {
            f.$name == RawColumn<String>("cool")
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$name == RawColumn<String>("cool")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."name" = "cool")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testWhereBind() {
        WHERE {
            RawColumn<String>("cool") == PSQLBind("yes")
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            RawColumn<String>("cool") == PSQLBind("yes")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("cool" = $1)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testWhereLikes() {
        WHERE {
            f.$name ~~ "like"
            f.$name !~~ "not like"
            f.$name ~~* "ilike"
            f.$name !~~* "not ilike"
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$name ~~ "like"
            p.$name !~~ "not like"
            p.$name ~~* "ilike"
            p.$name !~~* "not ilike"
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."name" LIKE 'like') AND ("x"."name" NOT LIKE 'not like') AND ("x"."name" ILIKE 'ilike') AND ("x"."name" NOT ILIKE 'not ilike')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testWhereTransforms() {
        WHERE {
            f.$name == "hi"
            f.$name.transform(to: Int.self) == 8
            f.$name.transform(to: Int.self) >< (8 ... 9)
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$name == "hi"
            p.$name.transform(to: Int.self) == 8
            p.$name.transform(to: Int.self) >< (8 ... 9)
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."name" = 'hi') AND ("x"."name" = 8) AND ("x"."name" BETWEEN 8 AND 9)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testWhereControlFlow() {
        let date = DateComponents(calendar: .current, timeZone: TimeZone(identifier: "UTC"), year: 2020, month: 01, day: 01, hour: 01, minute: 01, second: 01).date!

        enum Type {
            case current
            case missing
        }

        let t1 = Type.current
        let t2 = Type.missing

        WHERE {
            f.$birthday >< PSQLRange(from: date.psqlDate, to: date.psqlDate)

            switch t1 {
            case .current:
                f.$birthday >< PSQLRange(from: date.psqlDate, to: date.psqlDate)
            case .missing:
                f.$birthday >< PSQLRange(from: date.psqlTimestamp, to: date.psqlTimestamp)
            }

            switch t2 {
            case .current:
                f.$birthday >< PSQLRange(from: date.psqlDate, to: date.psqlDate)
            case .missing:
                f.$birthday >< PSQLRange(from: date.psqlTimestamp, to: date.psqlTimestamp)
            }
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$birthday >< PSQLRange(from: date.psqlDate, to: date.psqlDate)

            switch t1 {
            case .current:
                p.$birthday >< PSQLRange(from: date.psqlDate, to: date.psqlDate)
            case .missing:
                p.$birthday >< PSQLRange(from: date.psqlTimestamp, to: date.psqlTimestamp)
            }

            switch t2 {
            case .current:
                p.$birthday >< PSQLRange(from: date.psqlDate, to: date.psqlDate)
            case .missing:
                p.$birthday >< PSQLRange(from: date.psqlTimestamp, to: date.psqlTimestamp)
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."birthday" BETWEEN '2020-01-01' AND '2020-01-01') AND ("x"."birthday" BETWEEN '2020-01-01' AND '2020-01-01') AND ("x"."birthday" BETWEEN '2020-01-01 01:01 AM' AND '2020-01-01 01:01 AM')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        WHERE {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
            }
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            if bool {
                p.$name == "tmac"
            } else {
                p.$age == 29
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."name" = 'tmac')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        WHERE {
            if bool {
                f.$name == "tmac"
            } else {
                f.$age == 29
            }
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            if bool {
                p.$name == "tmac"
            } else {
                p.$age == 29
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testSwitch() {
        enum Test {
            case one
            case two
            case three
        }

        let option = Test.two

        WHERE {
            switch option {
            case .one: f.$name == "tmac"
            case .two: f.$age == 29
            case .three:
                f.$age == 29
                f.$name == "tmac"
            }
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            switch option {
            case .one: p.$name == "tmac"
            case .two: p.$age == 29
            case .three:
                p.$age == 29
                p.$name == "tmac"
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true
        WHERE {
            f.$age == 29
            if bool {
                f.$name == "tmac"
            }
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."age" = 29) AND ("x"."name" = 'tmac')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false
        WHERE {
            f.$age == 29
            if bool {
                f.$name == "tmac"
            }
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE ("x"."age" = 29)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    static var allTests = [
        ("testEqual", testEqual),
        ("testMultiple", testMultiple),
        ("testNotEqual", testNotEqual),
        ("testIn", testIn),
        ("testNotIn", testNotIn),
        ("testLiteral", testLiteral),
        ("testWhereOr", testWhereOr),
        ("testWhereRaw", testWhereRaw),
        ("testWhereBind", testWhereBind),
        ("testWhereLikes", testWhereLikes),
        ("testWhereTransforms", testWhereTransforms),
        ("testWhereControlFlow", testWhereControlFlow),
        ("testIfElseTrue", testIfElseTrue),
        ("testIfElseFalse", testIfElseFalse),
        ("testSwitch", testSwitch),
        ("testIfTrue", testIfTrue),
        ("testIfFalse", testIfFalse),
    ]
}
