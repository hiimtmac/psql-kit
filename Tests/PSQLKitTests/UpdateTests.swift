import XCTest
@testable import PSQLKit
import FluentKit

final class UpdateTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testEmpty() {
        UPDATE(FluentModel.table) {}
        .serialize(to: &fluentSerializer)
        
        UPDATE(PSQLModel.table) {}
        .serialize(to: &psqlkitSerializer)
        
        XCTAssertEqual(fluentSerializer.sql, #"UPDATE "my_model" SET "#)
        XCTAssertEqual(psqlkitSerializer.sql, #"UPDATE "my_model" SET "#)
    }
    
    func testModel() {
        UPDATE(FluentModel.table) {
            FluentModel.$name => "hi"
        }
        .serialize(to: &fluentSerializer)
        
        UPDATE(PSQLModel.table) {
            PSQLModel.$name => "hi"
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"UPDATE "my_model" SET "name" = 'hi'"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testModelAlias() {
        UPDATE(f.table) {
            f.$name => "hi"
        }
        .serialize(to: &fluentSerializer)

        UPDATE(p.table) {
            p.$name => "hi"
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi'"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testBoth() {
        UPDATE(f.table) {
            FluentModel.$name => "hi"
            f.$name => "hi"
        }
        .serialize(to: &fluentSerializer)

        UPDATE(p.table) {
            PSQLModel.$name => "hi"
            p.$name => "hi"
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi', "name" = 'hi'"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        UPDATE(f.table) {
            if bool {
                f.$name => "hi"
            } else {
                f.$age => 29
            }
        }
        .serialize(to: &fluentSerializer)

        UPDATE(p.table) {
            if bool {
                p.$name => "hi"
            } else {
                p.$age => 29
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"UPDATE "my_model" AS "x" SET "name" = 'hi'"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        UPDATE(f.table) {
            if bool {
                f.$name => "hi"
            } else {
                f.$age => 29
            }
        }
        .serialize(to: &fluentSerializer)

        UPDATE(p.table) {
            if bool {
                p.$name => "hi"
            } else {
                p.$age => 29
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"UPDATE "my_model" AS "x" SET "age" = 29"#
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

        UPDATE(f.table) {
            switch option {
            case .one: f.$name => "hi"
            case .two: f.$age => 29
            case .three:
                f.$age => 29
                f.$name => "hi"
            }
        }
        .serialize(to: &fluentSerializer)

        UPDATE(p.table) {
            switch option {
            case .one: p.$name => "hi"
            case .two: p.$age => 29
            case .three:
                p.$age => 29
                p.$name => "hi"
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"UPDATE "my_model" AS "x" SET "age" = 29"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testEmpty", testEmpty),
        ("testModel", testModel),
        ("testModelAlias", testModelAlias),
        ("testBoth", testBoth),
        ("testIfElseTrue", testIfElseTrue),
        ("testIfElseFalse", testIfElseFalse),
        ("testSwitch", testSwitch)
    ]
}
