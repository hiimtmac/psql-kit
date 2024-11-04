// GroupByTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class GroupByTests: PSQLTestCase {
    let f = FluentModel.as("x")

    func testGroupModel() {
        GROUPBY {
            FluentModel.$name
        }
        .serialize(to: &fluentSerializer)

        let compare = #"GROUP BY "my_model"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testGroupModelAlias() {
        GROUPBY {
            f.$name
        }
        .serialize(to: &fluentSerializer)

        let compare = #"GROUP BY "x"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testGroupBoth() {
        GROUPBY {
            FluentModel.$name
            f.$name
        }
        .serialize(to: &fluentSerializer)
        
        let compare = #"GROUP BY "my_model"."name", "x"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testGroupRaw() {
        GROUPBY {
            RawColumn<String>("cool")
        }
        .serialize(to: &fluentSerializer)

        let compare = #"GROUP BY "cool""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        GROUPBY {
            if bool {
                f.$name
            } else {
                f.$age
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"GROUP BY "x"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        GROUPBY {
            if bool {
                f.$name
            } else {
                f.$age
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"GROUP BY "x"."age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testSwitch() {
        enum Test {
            case one
            case two
            case three
        }

        let option = Test.two

        GROUPBY {
            switch option {
            case .one: f.$name
            case .two: f.$age
            case .three:
                f.$age
                f.$name
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"GROUP BY "x"."age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true
        GROUPBY {
            if bool {
                f.$name
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #"GROUP BY "x"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false
        GROUPBY {
            if bool {
                f.$name
            }
        }
        .serialize(to: &fluentSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }

    func testEmpty() {
        GROUPBY {}
            .serialize(to: &fluentSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
    }
}
