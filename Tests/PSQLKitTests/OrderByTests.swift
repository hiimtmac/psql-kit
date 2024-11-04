// OrderByTests.swift
// Copyright (c) 2024 hiimtmac inc.

import XCTest
@testable import PSQLKit

final class OrderByTests: PSQLTestCase {
    let p = PSQLModel.as("x")

    func testOrderModel() {
        ORDERBY {
            PSQLModel.$name
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "my_model"."name""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testOrderModelAlias() {
        ORDERBY {
            p.$name.asc()
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "x"."name" ASC"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testOrderMultiple() {
        ORDERBY {
            PSQLModel.$name.asc()
            p.$name.desc()
            p.$id
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "my_model"."name" ASC, "x"."name" DESC, "x"."id""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testOrderDirections() {
        ORDERBY {
            p.$name
            PSQLModel.$name.asc()
            PSQLModel.$name.desc()
            p.$name.order(.asc)
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "x"."name", "my_model"."name" ASC, "my_model"."name" DESC, "x"."name" ASC"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testOrderRaw() {
        ORDERBY {
            RawColumn<String>("cool").desc()
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "cool" DESC"#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true

        ORDERBY {
            if bool {
                p.$name
            } else {
                p.$age
            }
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "x"."name""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false

        ORDERBY {
            if bool {
                p.$name
            } else {
                p.$age
            }
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "x"."age""#
        XCTAssertEqual(serializer.sql, compare)
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
            case .one: p.$name
            case .two: p.$age
            case .three:
                p.$age
                p.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "x"."age""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfTrue() {
        let bool = true

        ORDERBY {
            if bool {
                p.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #"ORDER BY "x"."name""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testIfFalse() {
        let bool = false

        ORDERBY {
            if bool {
                p.$name
            }
        }
        .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }

    func testEmpty() {
        ORDERBY {}
            .serialize(to: &serializer)

        let compare = #""#
        XCTAssertEqual(serializer.sql, compare)
    }
}
