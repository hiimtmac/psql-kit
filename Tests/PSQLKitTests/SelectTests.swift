// SelectTests.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import SQLKit
import Testing
import PSQLKit

@Suite
struct SelectTests {
    let p = PSQLModel.as("x")

    @Test
    func testSelectModel() {
        var serializer = SQLSerializer.test

        SELECT {
            PSQLModel.$name
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "my_model"."name"::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSelectModelAlias() {
        var serializer = SQLSerializer.test

        SELECT {
            p.$name
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."name"::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSelectBoth() {
        var serializer = SQLSerializer.test

        SELECT {
            PSQLModel.$name
            p.$name
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "my_model"."name"::TEXT, "x"."name"::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSelectDistinctOn() {
        var serializer = SQLSerializer.test

        SELECT {
            PSQLModel.$name
        }
        .distinct {
            PSQLModel.$name
            p.$id
        }
        .serialize(to: &serializer)

        let compare = #"SELECT DISTINCT ON ("my_model"."name"::TEXT, "x"."id"::UUID) "my_model"."name"::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSelectDistinct() {
        var serializer = SQLSerializer.test

        SELECT {
            PSQLModel.$name
            p.$name
        }
        .distinct()
        .serialize(to: &serializer)

        let compare = #"SELECT DISTINCT "my_model"."name"::TEXT, "x"."name"::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSelectAliasSingle() {
        var serializer = SQLSerializer.test

        SELECT {
            PSQLModel.$name.as("nam")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "my_model"."name"::TEXT AS "nam""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSelectAliasMultiple() {
        var serializer = SQLSerializer.test

        SELECT {
            PSQLModel.$name.as("nam")
            p.$name.as("nam")
            p.$id
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "my_model"."name"::TEXT AS "nam", "x"."name"::TEXT AS "nam", "x"."id"::UUID"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSelectRaw() {
        var serializer = SQLSerializer.test

        let date = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!

        SELECT {
            RawColumn<String>("cool")
            RawColumn<String>("cool").as("yes")
            "cool".raw
            "cool".as(columnOf: String.self)
            8
            8.as("cool")
            8.raw
            PSQLDate(date)
            RawValue(PSQLDate(date))
            date.psqlDate
            date.psqlDate.as("date_alias")
            RawValue(date.psqlDate).as("raw_date_alias")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "cool"::TEXT, "cool"::TEXT AS "yes", 'cool'::TEXT, "cool"::TEXT, 8::INTEGER, 8::INTEGER AS "cool", 8::INTEGER, '2020-01-01'::DATE, '2020-01-01'::DATE, '2020-01-01'::DATE, '2020-01-01'::DATE AS "date_alias", '2020-01-01'::DATE AS "raw_date_alias""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testPostfix() {
        var serializer = SQLSerializer.test

        SELECT {
            PSQLModel.table.*
            p.table.*
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "my_model".*, "x".*"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfTrue() {
        var serializer = SQLSerializer.test

        let bool = true

        SELECT {
            p.$age
            if bool {
                p.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."age"::INTEGER, "x"."name"::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfFalse() {
        var serializer = SQLSerializer.test

        let bool = false

        SELECT {
            p.$age
            if bool {
                p.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."age"::INTEGER"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test

        let bool = true

        SELECT {
            if bool {
                p.$name
            } else {
                p.$age
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."name"::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test

        let bool = false

        SELECT {
            if bool {
                p.$name
            } else {
                p.$age
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."age"::INTEGER"#
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

        SELECT {
            switch option {
            case .one: p.$name
            case .two: p.$age
            case .three:
                p.$age
                p.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT "x"."age"::INTEGER"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test

        SELECT {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
