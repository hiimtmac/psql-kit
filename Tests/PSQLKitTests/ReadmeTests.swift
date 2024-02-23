// ReadmeTests.swift
// Copyright © 2022 hiimtmac

import FluentBenchmark
import PSQLKit
import XCTest

// needed because https://forums.swift.org/t/exported-import-does-not-properly-export-custom-operators/39090/5
infix operator ~~: ComparisonPrecedence
infix operator ...: LogicalConjunctionPrecedence

final class ReadmeTests: PSQLTestCase {
    func testWelcome() {
        QUERY {
            SELECT {
                Moon.$name
                Moon.$craters
            }
            FROM { Moon.table }
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testExecute() {
        let q = QUERY {
            SELECT {
                Moon.$name
                Moon.$craters
            }
            FROM { Moon.table }
        }

        let pq: some PSQLQuery = q
        let (sql, binding) = pq.raw()
        print(sql)
        print(binding)
    }

    func testColumnAlias() {
        SELECT {
            Moon.$name.as("moon_name")
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testTableAlias() {
        let m = Moon.as("m")
        SELECT {
            m.$name
            m.$craters.as("crater_count")
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testSelect() {
        let m = Moon.as("m")
        SELECT {
            m.*
            m.$name
            m.$craters
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testFrom() {
        let m = Moon.as("m")
        FROM {
            m.table
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testJoin() {
        let m = Moon.as("m")
        let p = Planet.as("p")
        QUERY {
            SELECT {
                m.*
                p.*
            }
            JOIN(p.table, method: .left) {
                m.$planet == p.$id
            }
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testWhere() {
        let m = Moon.as("m")
        WHERE {
            m.$name == "the moon"
            m.$craters > 3
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testComparisons() {
        let m = Moon.as("m")
        WHERE {
            m.$craters == 3 || m.$craters != 3 // = / !=
            m.$craters > 3 || m.$craters < 3 // > / <
            m.$craters >= 3 || m.$craters <= 3 // >= / <=
            m.$craters >< [3, 4, 5] || m.$craters <> [3, 4, 5] // IN / NOT IN
            m.$craters >< (3 ... 5) || m.$craters <> (3 ... 5) // BETWEEN / NOT BETWEEN
            m.$name ~~ "%moon" || m.$name !~~ "%moon" // LIKE / NOT LIKE
            m.$name ~~* "%moon" || m.$name !~~* "%moon" // ILIKE / NOT ILIKE
            m.$name === "moon" || m.$name !== "moon" // IS / IS NOT
            m.$name === Optional<String>.none
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testHaving() {
        let m = Moon.as("m")
        HAVING {
            AVG(m.$craters) > 1
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testGroupBy() {
        let m = Moon.as("m")
        GROUPBY {
            m.$name
            m.$craters
            m.$planet
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testOrderBy() {
        let m = Moon.as("m")
        ORDERBY {
            m.$name
            m.$name.desc()
            m.$craters.asc()
            m.$planet.order(.desc)
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testInsert() {
        let m = Moon.as("m")
        INSERT(into: m.table) {
            m.$name => "the moon"
            m.$craters => 10
            m.$comets => 20
            m.$planet => UUID()
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testUpdate() {
        let m = Moon.as("m")
        UPDATE(m.table) {
            m.$name => "cool moon"
            m.$craters => 30
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testDelete() {
        let m = Moon.as("m")
        DELETE { m.table }
            .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testQuery() {
        let m = Moon.as("m")
        QUERY {
            SELECT { m.* }
            FROM { m.table }
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testWith() {
        let m = Moon.as("m")
        WITH {
            QUERY {
                SELECT { m.* }
                FROM { m.table }
            }
            .asWith(m.table)
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testSubquery() {
        let m = Moon.as("m")
        QUERY {
            SELECT {
                QUERY {
                    SELECT { m.* }
                    FROM { m.table }
                }
                .asSubquery("x")
            }
            FROM {
                QUERY {
                    SELECT { m.* }
                    FROM { m.table }
                }
                .asSubquery("y")
            }
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testArithmetic() {
        let m = Moon.as("m")
        SELECT {
            (m.$craters / m.$comets).as("division")
            m.$craters + m.$comets
            m.$craters - m.$comets
            (m.$craters * m.$comets).as("multiply")
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testExpressions() {
        let m = Moon.as("m")
        SELECT {
            AVG(m.$craters)
            MIN(m.$craters)
            MAX(m.$craters)
            COUNT(m.$craters).as("crater_count")
            SUM(m.$craters)
            COALESCE(m.$craters, 5).as("unwrapped_craters")
            CONCAT(m.$name, " is a cool planet").as("annotated")
            GENERATE_SERIES(from: 1, to: 5, interval: 1)
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testTransform() {
        final class FluentModel: Model, Table {
            static let schema = "my_model"
            @ID
            var id: UUID?
            @Timestamp(key: "created_at", on: .create)
            var createdAt: Date?
        }

        let m = FluentModel.as("m")
        QUERY {
            SELECT {
                m.$id
                m.$id.transform(to: Int.self)
                m.$createdAt.as(PSQLDate.self)
            }
            WHERE {
                m.$id.transform(to: Int.self) == 7
                m.$createdAt >< (Date().psqlDate ... Date().psqlDate)
            }
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testRaw() {
        SELECT {
            RawColumn<String>("raw_column")
            RawColumn<Int>("raw_column").as("rawer")
            7
            666.as("number_of_the_beast")
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testBinding() {
        let m = Moon.as("m")
        WHERE {
            m.$name == "the moon".asBind()
            m.$comets > PSQLBind(8)
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
        print(fluentSerializer.binds)
    }

    func testUnion() {
        let m = Moon.as("m")
        let p = Planet.as("p")
        UNION {
            QUERY {
                SELECT { m.$name }
                FROM { m.table }
            }
            QUERY {
                SELECT { p.$name }
                FROM { p.table }
            }
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testDistinct() {
        let m = Moon.as("m")
        let p = Planet.as("p")
        QUERY {
            WITH {
                QUERY {
                    SELECT { m.$name }
                        .distinct {
                            m.$name
                            m.$id
                        }
                }
                .asWith("x")
                QUERY {
                    SELECT {
                        p.$name
                        p.$id
                    }
                    .distinct()
                }
                .asWith("y")
            }
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }

    func testSchema() {
        final class FluentModel: Model, Table {
            static let schema = "my_model"
            static let path: String? = "custom_path"
            @ID
            var id: UUID?
            @Field(key: "name")
            var name: String
        }
        let m = FluentModel.as("m")
        QUERY {
            SELECT { m.* }
            FROM { m.table }
        }
        .serialize(to: &fluentSerializer)
        print(fluentSerializer.sql)
    }
}

extension Galaxy: Table {}

extension Moon: Table {}

extension Planet: Table {}

extension PlanetTag: Table {}

extension Star: Table {}

extension Tag: Table {}
