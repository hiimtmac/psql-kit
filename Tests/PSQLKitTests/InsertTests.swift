import XCTest
@testable import PSQLKit
import FluentKit

final class InsertTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")
    
    func testEmpty() {
        INSERT(into: FluentModel.table) {}
        .serialize(to: &fluentSerializer)
        
        INSERT(into: PSQLModel.table) {}
        .serialize(to: &psqlkitSerializer)
        
        XCTAssertEqual(fluentSerializer.sql, #"INSERT INTO "my_model" () VALUES ()"#)
        XCTAssertEqual(psqlkitSerializer.sql, #"INSERT INTO "my_model" () VALUES ()"#)
    }
    
    func testModel() {
        INSERT(into: FluentModel.table) {
            FluentModel.$name => "hi"
        }
        .serialize(to: &fluentSerializer)
        
        INSERT(into: PSQLModel.table) {
            PSQLModel.$name => "hi"
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"INSERT INTO "my_model" ("name") VALUES ('hi')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testModelAlias() {
        INSERT(into: f.table) {
            f.$name => "hi"
        }
        .serialize(to: &fluentSerializer)

        INSERT(into: p.table) {
            p.$name => "hi"
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name") VALUES ('hi')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testBoth() {
        INSERT(into: f.table) {
            FluentModel.$name => "hi"
            f.$name => "hi"
        }
        .serialize(to: &fluentSerializer)

        INSERT(into: p.table) {
            PSQLModel.$name => "hi"
            p.$name => "hi"
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name", "name") VALUES ('hi', 'hi')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfElseTrue() {
        let bool = true
        INSERT(into: f.table) {
            if bool {
                f.$name => "hi"
            } else {
                f.$age => 29
            }
        }
        .serialize(to: &fluentSerializer)

        INSERT(into: p.table) {
            if bool {
                p.$name => "hi"
            } else {
                p.$age => 29
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("name") VALUES ('hi')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testIfElseFalse() {
        let bool = false
        INSERT(into: f.table) {
            if bool {
                f.$name => "hi"
            } else {
                f.$age => 29
            }
        }
        .serialize(to: &fluentSerializer)

        INSERT(into: p.table) {
            if bool {
                p.$name => "hi"
            } else {
                p.$age => 29
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("age") VALUES (29)"#
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

        INSERT(into: f.table) {
            switch option {
            case .one: f.$name => "hi"
            case .two: f.$age => 29
            case .three:
                f.$age => 29
                f.$name => "hi"
            }
        }
        .serialize(to: &fluentSerializer)

        INSERT(into: p.table) {
            switch option {
            case .one: p.$name => "hi"
            case .two: p.$age => 29
            case .three:
                p.$age => 29
                p.$name => "hi"
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"INSERT INTO "my_model" AS "x" ("age") VALUES (29)"#
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
