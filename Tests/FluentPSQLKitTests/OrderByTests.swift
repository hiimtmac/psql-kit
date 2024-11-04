// OrderByTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class OrderByTests: PSQLTestCase {
    let f = FluentModel.as("x")

    func testOrderModel() {
        ORDERBY {
            FluentModel.$name
        }
        .serialize(to: &fluentSerializer)

        let compare = #"ORDER BY "my_model"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testOrderModelAlias() {
        ORDERBY {
            f.$name.asc()
        }
        .serialize(to: &fluentSerializer)

        let compare = #"ORDER BY "x"."name" ASC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testOrderMultiple() {
        ORDERBY {
            FluentModel.$name.asc()
            f.$name.desc()
            f.$id
        }
        .serialize(to: &fluentSerializer)

        let compare = #"ORDER BY "my_model"."name" ASC, "x"."name" DESC, "x"."id""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testOrderDirections() {
        ORDERBY {
            f.$name
            FluentModel.$name.asc()
            FluentModel.$name.desc()
            f.$name.order(.asc)
        }
        .serialize(to: &fluentSerializer)

        let compare = #"ORDER BY "x"."name", "my_model"."name" ASC, "my_model"."name" DESC, "x"."name" ASC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testOrderRaw() {
        ORDERBY {
            RawColumn<String>("cool").desc()
        }
        .serialize(to: &fluentSerializer)

        let compare = #"ORDER BY "cool" DESC"#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        ORDERBY {
            if bool {
                f.$name
            } else {
                f.$age
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"ORDER BY "x"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        ORDERBY {
            if bool {
                f.$name
            } else {
                f.$age
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"ORDER BY "x"."age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testSwitch() {
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
        .serialize(to: &fluentSerializer)

        let compare = #"ORDER BY "x"."age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true
        ORDERBY {
            if bool {
                f.$name
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"ORDER BY "x"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false
        ORDERBY {
            if bool {
                f.$name
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testEmpty() {
        ORDERBY {}
            .serialize(to: &fluentSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
