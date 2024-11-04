// GroupByTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class GroupByTests: PSQLTestCase {
    let p = PSQLModel.as("x")

    func testGroupModel() {
        GROUPBY {
            PSQLModel.$name
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "my_model"."name""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testGroupModelAlias() {
        GROUPBY {
            p.$name
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "x"."name""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testGroupBoth() {
        GROUPBY {
            PSQLModel.$name
            p.$name
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "my_model"."name", "x"."name""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testGroupRaw() {
        GROUPBY {
            RawColumn<String>("cool")
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "cool""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true

        GROUPBY {
            if bool {
                p.$name
            } else {
                p.$age
            }
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "x"."name""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false

        GROUPBY {
            if bool {
                p.$name
            } else {
                p.$age
            }
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "x"."age""#
        XCTAssertEqual(serializer.sql, compare)
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
            case .one: p.$name
            case .two: p.$age
            case .three:
                p.$age
                p.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "x"."age""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true

        GROUPBY {
            if bool {
                p.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #"GROUP BY "x"."name""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false

        GROUPBY {
            if bool {
                p.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testEmpty() {
        GROUPBY {}
            .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
