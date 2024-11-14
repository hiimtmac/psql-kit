// WhereTests.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import SQLKit
import Testing
import PSQLKit

// needed because https://forums.swift.org/t/exported-import-does-not-properly-export-custom-operators/39090/5
infix operator ~~: ComparisonPrecedence
infix operator ...: LogicalConjunctionPrecedence

@Suite
struct WhereTests {
    let p = PSQLModel.as("x")

    @Test
    func testEqual() {
        var serializer = SQLSerializer.test

        WHERE {
            PSQLModel.$name == PSQLModel.$title
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("my_model"."name" = "my_model"."title")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEnum() {
        var serializer = SQLSerializer.test

        WHERE {
            PSQLModel.$category != PSQLModel.$category
            PSQLModel.$category == PSQLModel.Category.yes.rawValue
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("my_model"."category" != "my_model"."category") AND ("my_model"."category" = 'yes')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testMultiple() {
        var serializer = SQLSerializer.test

        WHERE {
            PSQLModel.$name == p.$title
            p.$name != PSQLModel.$title
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("my_model"."name" = "x"."title") AND ("x"."name" != "my_model"."title")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testNotEqual() {
        var serializer = SQLSerializer.test

        WHERE {
            p.$name != p.$title
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" != "x"."title")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testNotIn() {
        var serializer = SQLSerializer.test

        WHERE {
            p.$name <> ["name", "hi"]
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" NOT IN ('name', 'hi'))"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIn() {
        var serializer = SQLSerializer.test

        WHERE {
            p.$name >< ["name", "hi"]
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" IN ('name', 'hi'))"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testBetween() {
        var serializer = SQLSerializer.test

        WHERE {
            p.$age >< (20 ... 30)
            p.$age >< ((p.$age) ... (p.$age))
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."age" BETWEEN 20 AND 30) AND ("x"."age" BETWEEN "x"."age" AND "x"."age")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testNotBetween() {
        var serializer = SQLSerializer.test

        WHERE {
            p.$age <> (20 ... 30)
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."age" NOT BETWEEN 20 AND 30)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testLiteral() {
        var serializer = SQLSerializer.test

        WHERE {
            p.$name == "hello"
            p.$name != "hello"
            p.$age < 29
            p.$age <= 29
            p.$age > 29
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" = 'hello') AND ("x"."name" != 'hello') AND ("x"."age" < 29) AND ("x"."age" <= 29) AND ("x"."age" > 29)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testWhereOr() {
        var serializer = SQLSerializer.test

        WHERE {
            p.$name <> ["name", "hi"] || PSQLModel.$name != PSQLModel.$name
        }
        .serialize(to: &serializer)

        let compare = #"WHERE (("x"."name" NOT IN ('name', 'hi')) OR ("my_model"."name" != "my_model"."name"))"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testWhereRaw() {
        var serializer = SQLSerializer.test

        WHERE {
            p.$name == RawColumn<String>("cool")
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" = "cool")"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testWhereBind() {
        var serializer = SQLSerializer.test

        WHERE {
            RawColumn<String>("cool") == PSQLBind("yes")
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("cool" = $1)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testWhereLikes() {
        var serializer = SQLSerializer.test

        WHERE {
            p.$name ~~ "like"
            p.$name !~~ "not like"
            p.$name ~~* "ilike"
            p.$name !~~* "not ilike"
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" LIKE 'like') AND ("x"."name" NOT LIKE 'not like') AND ("x"."name" ILIKE 'ilike') AND ("x"."name" NOT ILIKE 'not ilike')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testWhereTransforms() {
        var serializer = SQLSerializer.test

        WHERE {
            p.$name == "hi"
            p.$name.transform(to: Int.self) == 8
            p.$name.transform(to: Int.self) >< (8 ... 9)
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."name" = 'hi') AND ("x"."name" = 8) AND ("x"."name" BETWEEN 8 AND 9)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testWhereControlFlow() {
        var serializer = SQLSerializer.test

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
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test

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
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test

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
        #expect(serializer.sql == compare)
    }

    @Test
    func testSwitch() {
        var serializer = SQLSerializer.test

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
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfTrue() {
        var serializer = SQLSerializer.test

        let bool = true

        WHERE {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."age" = 29) AND ("x"."name" = 'tmac')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfFalse() {
        var serializer = SQLSerializer.test

        let bool = false

        WHERE {
            p.$age == 29
            if bool {
                p.$name == "tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"WHERE ("x"."age" = 29)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test

        WHERE {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
