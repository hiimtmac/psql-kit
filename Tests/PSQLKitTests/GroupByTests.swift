// GroupByTests.swift
// Copyright © 2022 hiimtmac

import FluentKit
import XCTest
@testable import PSQLKit

final class GroupByTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")

    func testGroupModel() {
        GROUPBY {
            FluentModel.$name
        }
        .serialize(to: &fluentSerializer)

        GROUPBY {
            PSQLModel.$name
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"GROUP BY "my_model"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testGroupModelAlias() {
        GROUPBY {
            f.$name
        }
        .serialize(to: &fluentSerializer)

        GROUPBY {
            p.$name
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"GROUP BY "x"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testGroupBoth() {
        GROUPBY {
            FluentModel.$name
            f.$name
        }
        .serialize(to: &fluentSerializer)

        GROUPBY {
            PSQLModel.$name
            p.$name
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"GROUP BY "my_model"."name", "x"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testGroupRaw() {
        GROUPBY {
            RawColumn<String>("cool")
        }
        .serialize(to: &fluentSerializer)

        GROUPBY {
            RawColumn<String>("cool")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"GROUP BY "cool""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
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

        GROUPBY {
            if bool {
                p.$name
            } else {
                p.$age
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"GROUP BY "x"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
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

        GROUPBY {
            if bool {
                p.$name
            } else {
                p.$age
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"GROUP BY "x"."age""#
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

        GROUPBY {
            switch option {
            case .one: p.$name
            case .two: p.$age
            case .three:
                p.$age
                p.$name
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"GROUP BY "x"."age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true
        GROUPBY {
            if bool {
                f.$name
            }
        }
        .serialize(to: &fluentSerializer)

        GROUPBY {
            if bool {
                p.$name
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"GROUP BY "x"."name""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false
        GROUPBY {
            if bool {
                f.$name
            }
        }
        .serialize(to: &fluentSerializer)

        GROUPBY {
            if bool {
                p.$name
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    static var allTests = [
        ("testGroupModel", testGroupModel),
        ("testGroupModelAlias", testGroupModelAlias),
        ("testGroupBoth", testGroupBoth),
        ("testGroupRaw", testGroupRaw),
        ("testIfElseTrue", testIfElseTrue),
        ("testIfElseFalse", testIfElseFalse),
        ("testSwitch", testSwitch),
        ("testIfTrue", testIfTrue),
        ("testIfFalse", testIfFalse),
    ]
}
