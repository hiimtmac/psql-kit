import XCTest
import PSQLKit
import FluentKit
import FluentBenchmark

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
        .serialize(to: &serializer)
        
        print(serializer.sql)
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
        .serialize(to: &serializer)
        print(serializer.sql)
    }
    
    func testTableAlias() {
let m = Moon.as("m")
SELECT {
    m.$name
    m.$craters.as("crater_count")
}
        .serialize(to: &serializer)
        print(serializer.sql)
    }
    
    func testSelect() {
let m = Moon.as("m")
SELECT {
    m.*
    m.$name
    m.$craters
}
        .serialize(to: &serializer)
        print(serializer.sql)
    }
    
    func testFrom() {
let m = Moon.as("m")
FROM {
    m.table
}
        .serialize(to: &serializer)
        print(serializer.sql)
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
        .serialize(to: &serializer)
        print(serializer.sql)
    }
    
    func testWhere() {
let m = Moon.as("m")
WHERE {
    m.$name == "the moon"
    m.$craters > 3
}
        .serialize(to: &serializer)
        print(serializer.sql)
    }
    
    func testComparrisons() {
let m = Moon.as("m")
WHERE {
    m.$craters == 3 || m.$craters != 3 // = / !=
    m.$craters > 3 || m.$craters < 3 // > / <
    m.$craters >= 3 || m.$craters <= 3 // >= / <=
    m.$craters >< [3,4,5] || m.$craters <> [3,4,5] // IN / NOT IN
    m.$craters >< (3...5) || m.$craters <> (3...5) // BETWEEN / NOT BETWEEN
    m.$name ~~ "%moon" || m.$name !~~ "%moon" // LIKE / NOT LIKE
    m.$name ~~* "%moon" || m.$name !~~* "%moon" // ILIKE / NOT ILIKE
}
        .serialize(to: &serializer)
        print(serializer.sql)
    }
    
    func testHaving() {
let m = Moon.as("m")
HAVING {
    AVG(m.$craters) > 1
}
        .serialize(to: &serializer)
        print(serializer.sql)
    }
    
    func testGroupBy() {
let m = Moon.as("m")
GROUPBY {
    m.$name
    m.$craters
    m.$planet
}
        .serialize(to: &serializer)
        print(serializer.sql)
    }
    
    func testOrderBy() {
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
    
    func testQuery() {
let m = Moon.as("m")
QUERY {
    SELECT { m.* }
    FROM { m.table }
}
        .serialize(to: &serializer)
        print(serializer.sql)
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
        .serialize(to: &serializer)
        print(serializer.sql)
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
        .serialize(to: &serializer)
        print(serializer.sql)
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
        .serialize(to: &serializer)
        print(serializer.sql)
    }
    
    func testTransform() {
final class MyModel: Model, Table {
    static let schema = "my_model"
    @ID var id: UUID?
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?
}

let m = MyModel.as("m")
WHERE {
    m.$createdAt.transform(to: PSQLDate.self) >< (Date().psqlDate...Date().psqlDate)
}
        .serialize(to: &serializer)
        print(serializer.sql)
    }
    
    func testRaw() {
SELECT {
    RawColumn<String>("raw_column")
    RawColumn<Int>("raw_column").as("rawer")
    7
    666.as("number_of_the_beast")
}
        .serialize(to: &serializer)
        print(serializer.sql)
    }
    
    func testBinding() {
let m = Moon.as("m")
WHERE {
    m.$name == "the moon".asBind()
    m.$comets > PSQLBind(8)
}
        .serialize(to: &serializer)
        print(serializer.sql)
        print(serializer.binds)
    }
    
    func testGroupings() {
let m = Moon.as("m")
let p = Planet.as("p")
QUERY {
    SELECT {
        m.$name
        SELECTGROUP { m.$name }
        SELECTGROUP { m.$name }
    }
    JOIN(p.table) { p.$id == m.$planet }
    QUERYGROUP {
        JOIN(p.table) {
            p.$id == m.$planet
            JOINGROUP {
                p.$id == m.$planet
            }
        }
    }
}
        .serialize(to: &serializer)
        print(serializer.sql)
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
        .serialize(to: &serializer)
        print(serializer.sql)
    }
    
    func testDistinct() {
let m = Moon.as("m")
let p = Planet.as("p")
QUERY {
    WITH {
        QUERY {
            SELECT { m.$name }
                .distinctOn {
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
}

extension Galaxy: Table {}
    
extension Moon: Table {}
    
extension Planet: Table {}
    
extension PlanetTag: Table {}
    
extension Star: Table {}
    
extension Tag: Table {}
