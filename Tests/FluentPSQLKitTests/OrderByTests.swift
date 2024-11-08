// OrderByTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct OrderByTests {
    let f = FluentModel.as("x")

    @Test
    func testOrderModel() {
        var serializer = SQLSerializer.test
        ORDERBY {
            FluentModel.$name
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "my_model"."name""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testOrderModelAlias() {
        var serializer = SQLSerializer.test
        ORDERBY {
            f.$name.asc()
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "x"."name" ASC"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testOrderMultiple() {
        var serializer = SQLSerializer.test
        ORDERBY {
            FluentModel.$name.asc()
            f.$name.desc()
            f.$id
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "my_model"."name" ASC, "x"."name" DESC, "x"."id""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testOrderDirections() {
        var serializer = SQLSerializer.test
        ORDERBY {
            f.$name
            FluentModel.$name.asc()
            FluentModel.$name.desc()
            f.$name.order(.asc)
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "x"."name", "my_model"."name" ASC, "my_model"."name" DESC, "x"."name" ASC"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testOrderRaw() {
        var serializer = SQLSerializer.test
        ORDERBY {
            RawColumn<String>("cool").desc()
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "cool" DESC"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseTrue() {
        var serializer = SQLSerializer.test
        let bool = true
        ORDERBY {
            if bool {
                f.$name
            } else {
                f.$age
            }
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "x"."name""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfElseFalse() {
        var serializer = SQLSerializer.test
        let bool = false
        ORDERBY {
            if bool {
                f.$name
            } else {
                f.$age
            }
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "x"."age""#
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

        ORDERBY {
            switch option {
            case .one: f.$name
            case .two: f.$age
            case .three:
                f.$age
                f.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "x"."age""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfTrue() {
        var serializer = SQLSerializer.test
        let bool = true
        ORDERBY {
            if bool {
                f.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "x"."name""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testIfFalse() {
        var serializer = SQLSerializer.test
        let bool = false
        ORDERBY {
            if bool {
                f.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testEmpty() {
        var serializer = SQLSerializer.test
        ORDERBY {}
            .serialize(to: &serializer)

        let compare = #""#
        #expect(serializer.sql == compare)
    }
}
