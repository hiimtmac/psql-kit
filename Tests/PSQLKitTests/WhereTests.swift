// WhereTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

// needed because https://forums.swift.org/t/exported-import-does-not-properly-export-custom-operators/39090/5
infix operator ~~: ComparisonPrecedence
infix operator ...: LogicalConjunctionPrecedence

final class WhereTests: PSQLTestCase {
    let p = PSQLModel.as("x")

    func testEqual() {
        WHERE {
            PSQLModel.$name == PSQLModel.$title
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("my_model"."name" = "my_model"."title")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testEnum() {
        WHERE {
            PSQLModel.$category != PSQLModel.$category
            PSQLModel.$category == PSQLModel.Category.yes.rawValue
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("my_model"."category" != "my_model"."category") AND ("my_model"."category" = 'yes')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testMultiple() {
        WHERE {
            PSQLModel.$name == p.$title
            p.$name != PSQLModel.$title
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("my_model"."name" = "x"."title") AND ("x"."name" != "my_model"."title")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testNotEqual() {
        WHERE {
            p.$name != p.$title
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" != "x"."title")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIn() {
        WHERE {
            p.$name <> ["name", "hi"]
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" NOT IN ('name', 'hi'))"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testNotIn() {
        WHERE {
            p.$name >< ["name", "hi"]
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" IN ('name', 'hi'))"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testBetween() {
        WHERE {
            p.$age >< (20 ... 30)
            p.$age >< ((p.$age) ... (p.$age))
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."age" BETWEEN 20 AND 30) AND ("x"."age" BETWEEN "x"."age" AND "x"."age")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testNotBetween() {
        WHERE {
            p.$age <> (20 ... 30)
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."age" NOT BETWEEN 20 AND 30)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testLiteral() {
        WHERE {
            p.$name == "hello"
            p.$name != "hello"
            p.$age < 29
            p.$age <= 29
            p.$age > 29
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" = 'hello') AND ("x"."name" != 'hello') AND ("x"."age" < 29) AND ("x"."age" <= 29) AND ("x"."age" > 29)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testWhereOr() {
        WHERE {
            p.$name <> ["name", "hi"] || PSQLModel.$name != PSQLModel.$name
        }
        .serialize(to: &serializer)

        let compare = #"WHERE (("x"."name" NOT IN ('name', 'hi')) OR ("my_model"."name" != "my_model"."name"))"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testWhereRaw() {
        WHERE {
            p.$name == RawColumn<String>("cool")
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" = "cool")"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testWhereBind() {
        WHERE {
            RawColumn<String>("cool") == PSQLBind("yes")
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("cool" = $1)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testWhereLikes() {
        WHERE {
            p.$name ~~ "like"
            p.$name !~~ "not like"
            p.$name ~~* "ilike"
            p.$name !~~* "not ilike"
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" LIKE 'like') AND ("x"."name" NOT LIKE 'not like') AND ("x"."name" ILIKE 'ilike') AND ("x"."name" NOT ILIKE 'not ilike')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testWhereTransforms() {
        WHERE {
            p.$name == "hi"
            p.$name.transform(to: Int.self) == 8
            p.$name.transform(to: Int.self) >< (8 ... 9)
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" = 'hi') AND ("x"."name" = 8) AND ("x"."name" BETWEEN 8 AND 9)"#
        XCTAssertEqual(serializer.sql, compare)
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
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."birthday" BETWEEN '2020-01-01' AND '2020-01-01') AND ("x"."birthday" BETWEEN '2020-01-01' AND '2020-01-01') AND ("x"."birthday" BETWEEN '2020-01-01 01:01 AM' AND '2020-01-01 01:01 AM')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true

        WHERE {
            if bool {
                p.$name == "tmac"
            } else {
                p.$age == 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" = 'tmac')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false

        WHERE {
            if bool {
                p.$name == "tmac"
            } else {
                p.$age == 29
            }
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."age" = 29)"#
        XCTAssertEqual(serializer.sql, compare)
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
            case .one: p.$name == "tmac"
            case .two: p.$age == 29
            case .three:
                p.$age == 29
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."age" = 29)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true

        WHERE {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."age" = 29) AND ("x"."name" = 'tmac')"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false

        WHERE {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."age" = 29)"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testEmpty() {
        WHERE {}
            .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
