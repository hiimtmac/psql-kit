// ReadmeTests.swift
// Copyright (c) 2024 hiimtmac inc.

import FluentBenchmark
import FluentPSQLKit
import PSQLKit
import SQLKit
import Testing

// needed because https://forums.swift.org/t/exported-import-does-not-properly-export-custom-operators/39090/5
infix operator ~~: ComparisonPrecedence
infix operator ...: LogicalConjunctionPrecedence

@Suite
struct ReadmeTests {
    @Test
    func testWelcome() {
        var serializer = SQLSerializer.test
        QUERY {
            SELECT {
                Moon.$name
                Moon.$craters
            }
            FROM { Moon.table }
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
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

    @Test
    func testColumnAlias() {
        var serializer = SQLSerializer.test
        SELECT {
            Moon.$name.as("moon_name")
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testTableAlias() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        SELECT {
            m.$name
            m.$craters.as("crater_count")
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testSelect() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        SELECT {
            m.*
            m.$name
            m.$craters
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testFrom() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        FROM {
            m.table
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testJoin() {
        var serializer = SQLSerializer.test
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
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testWhere() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        WHERE {
            m.$name == "the moon"
            m.$craters > 3
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testComparisons() {
        var serializer = SQLSerializer.test
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
            m.$name === String?.none
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testHaving() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        HAVING {
            AVG(m.$craters) > 1
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testGroupBy() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        GROUPBY {
            m.$name
            m.$craters
            m.$planet
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testOrderBy() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        ORDERBY {
            m.$name
            m.$name.desc()
            m.$craters.asc()
            m.$planet.order(.desc)
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testInsert() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        INSERT(into: m.table) {
            m.$name => "the moon"
            m.$craters => 10
            m.$comets => 20
            m.$planet => UUID()
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testUpdate() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        UPDATE(m.table) {
            m.$name => "cool moon"
            m.$craters => 30
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testDelete() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        DELETE { m.table }
            .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testQuery() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        QUERY {
            SELECT { m.* }
            FROM { m.table }
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testWith() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        WITH {
            QUERY {
                SELECT { m.* }
                FROM { m.table }
            }
            .asWith(m.table)
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testSubquery() {
        var serializer = SQLSerializer.test
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
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testArithmetic() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        SELECT {
            (m.$craters / m.$comets).as("division")
            m.$craters + m.$comets
            m.$craters - m.$comets
            (m.$craters * m.$comets).as("multiply")
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testExpressions() {
        var serializer = SQLSerializer.test
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
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @FluentCTE("my_model")
    final class FluentModel1: Model, @unchecked Sendable {
        @ID
        var id: UUID?
        @Timestamp(key: "created_at", on: .create)
        var createdAt: Date?
        init() {}
    }

    @Test
    func testTransform() {
        var serializer = SQLSerializer.test
        let m = FluentModel1.as("m")
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
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testRaw() {
        var serializer = SQLSerializer.test
        SELECT {
            RawColumn<String>("raw_column")
            RawColumn<Int>("raw_column").as("rawer")
            7
            666.as("number_of_the_beast")
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testBinding() {
        var serializer = SQLSerializer.test
        let m = Moon.as("m")
        WHERE {
            m.$name == "the moon".asBind()
            m.$comets > PSQLBind(8)
        }
        .serialize(to: &serializer)
        print(serializer.sql)
        print(serializer.binds)
    }

    @Test
    func testUnion() {
        var serializer = SQLSerializer.test
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
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @Test
    func testDistinct() {
        var serializer = SQLSerializer.test
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
        .serialize(to: &serializer)
        print(serializer.sql)
    }

    @FluentCTE("my_model", schemaName: "custom_path")
    final class FluentModel2: Model, @unchecked Sendable {
        @ID
        var id: UUID?
        @Field(key: "name")
        var name: String
        init() {}
    }

    @Test
    func testSchema() {
        var serializer = SQLSerializer.test
        let m = FluentModel2.as("m")
        QUERY {
            SELECT { m.* }
            FROM { m.table }
        }
        .serialize(to: &serializer)
        print(serializer.sql)
    }
}

extension Galaxy: Table {
    public static let queryContainer = QueryContainer()
    public struct QueryContainer: Sendable {
        @ColumnAccessor<IDValue>("id") var id: Never
        @ColumnAccessor<String>("name") var name: Never
    }
}

extension Moon: Table {
    public static let queryContainer = QueryContainer()
    public struct QueryContainer: Sendable {
        @ColumnAccessor<IDValue>("id") var id: Never
        @ColumnAccessor<String>("name") var name: Never
        @ColumnAccessor<Int>("craters") var craters: Never
        @ColumnAccessor<Int>("comets") var comets: Never
        @ColumnAccessor<Planet.IDValue>("planet_id") var planet: Never
    }
}

extension Planet: Table {
    public static let queryContainer = QueryContainer()
    public struct QueryContainer: Sendable {
        @ColumnAccessor<IDValue>("id") var id: Never
        @ColumnAccessor<String>("name") var name: Never
    }
}

extension PlanetTag: Table {
    public static let queryContainer = QueryContainer()
    public struct QueryContainer: Sendable {
        @ColumnAccessor<IDValue>("id") var id: Never
        @ColumnAccessor<String>("name") var name: Never
    }
}

extension Star: Table {
    public static let queryContainer = QueryContainer()
    public struct QueryContainer: Sendable {
        @ColumnAccessor<IDValue>("id") var id: Never
        @ColumnAccessor<String>("name") var name: Never
    }
}

extension FluentBenchmark.Tag: Table {
    public static let queryContainer = QueryContainer()
    public struct QueryContainer: Sendable {
        @ColumnAccessor<IDValue>("id") var id: Never
        @ColumnAccessor<String>("name") var name: Never
    }
}
