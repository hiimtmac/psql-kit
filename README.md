# PSQLKit

PSQL query function builders for [FluentKit](https://github.com/vapor/fluent-kit.git) models (and others). This package is purely additive and allows you to use Fluent ORM still but drop down to strongly typed builders for more complex queries (and avoid string queries 👍🏻).

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/hiimtmac/PSQLKit.git", from: "0.11.0")
],
```

> **Warning**: This is a pre-release and is subject to change

## Getting Started

The easiest way to get started is to conform Fluent `Model`s to `Table`

```swift
// existing model from FluentBenchmark
public final class Moon: Model {
    public static let schema = "moons"

    @ID(key: .id) public var id: UUID?
    @Field(key: "name") public var name: String
    @Field(key: "craters") public var craters: Int
    @Field(key: "comets") public var comets: Int
    @Parent(key: "planet_id") public var planet: Planet

    public init() { }

    ...
}

// Add conformance to `Table`, you now have strong typed function builder support!
extension Moon: Table {}
```

Now you can use the function builders to make a query:

```swift
QUERY {
    SELECT {
        Moon.$name
        Moon.$craters
    }
    FROM { Moon.table }
}
```

```sql
SELECT "moons"."name"::TEXT, "moons"."craters"::INTEGER FROM "moons"
```

### `PSQLQuery`

The query builders store all your types as you build them up. For example, the above type is `QueryDirective<QueryTouple<(SelectDirective<SelectTouple<(ColumnExpression<String>, ColumnExpression<Int>)>>, FromDirective<Moon>)>>`. This is obviously nasty if you want to pass it around as functions. To combat this, you can return a `QUERY` as `some PSQLQuery`. This will also give you some added functionality for executing and debugging (`QUERY` can also be executed or inspected).

`.raw()` can be used to inspect your query

```swift
let q = QUERY {
    SELECT {
        Moon.$name
        Moon.$craters
    }
    FROM { Moon.table }
}

let pq: some PSQLQuery = q
let (sql, binding) = pq.raw()
print(sql) // SELECT "moons"."name"::TEXT, "moons"."craters"::INTEGER FROM "moons"
print(binding) // []
```

`.execute(on database: Database)` can be used to run your query, from here you have access to `.all(decoding: T.self)` and `.first(decoding: T.self)` to decode the return from the database.

```swift
struct MyModel: Codable {
    let name: String
}

func index(_ req: Request) throws -> EventLoopFuture<[MyModel]> {
    QUERY {
        SELECT { Moon.$name }
        FROM { Moon.table }
    }
    .execute(on: req.db)
    .all(decoding: MyModel.self)
}
```

### Alias

Aliasing support is included for `... AS ...` in your queries

#### Column Alias

In a `SELECT` builder, use `.as(_ alias: String)` to alias the column you are selecting

```swift
SELECT {
    Moon.$name.as("moon_name")
}
```

```sql
SELECT "moons"."name"::TEXT AS "moon_name"
```

#### Table Alias

You can alias a `Table` using static function `.as(_ alias: String)`. You can then use this in all the rest of your query building

```swift
let m = Moon.as("m")
SELECT {
    m.$name
    m.$craters.as("crater_count")
}
```

```sql
SELECT "m"."name"::TEXT, "m"."craters"::INTEGER AS "crater_count"
```

### Directives

The following directives have been included. Examples below show using models from `FluentBenchmark`. All methods on `Table` conformances work both statically (ie `MyModel.$id`) or on a table alias (ie `m.$id`) but table alias seems to give better autocomplete.

#### SELECT

Postfix operator `.*` is also available to select all columns

```swift
let m = Moon.as("m")
SELECT {
    m.*
    m.$name
    m.$craters
}
```

```sql
SELECT "m".*, "m"."name"::TEXT, "m"."craters"::INTEGER
```

#### FROM

Use `.table` to access the table for `FROM` and `JOIN`

```swift
let m = Moon.as("m")
FROM {
    m.table
}
```

```sql
FROM "moons" AS "m"
```

#### JOIN

Choose the join method in the second parameter, otherwise ommitting it will default to `INNER JOIN`. You can use multiple conditions for the join (one per line in the function builder). You can also use a `bool` if you want all to join (ie `JOIN(MyModel.table) { true }`)

```swift
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
```

```sql
SELECT "m".*, "p".* LEFT JOIN "planets" AS "p" ON ("m"."planet_id" = "p"."id")
```

#### WHERE

Comparisons (like `JOIN` above) will try to help and only allow you to compare types that are equal (so you can't compare a `String` column against an `Int`)

```swift
let m = Moon.as("m")
WHERE {
    m.$craters == 3 || m.$craters != 3 // = / !=
    m.$craters > 3 || m.$craters < 3 // > / <
    m.$craters >= 3 || m.$craters <= 3 // >= / <=
    m.$craters >< [3,4,5] || m.$craters <> [3,4,5] // IN / NOT IN
    m.$craters >< (3...5) || m.$craters <> (3...5) // BETWEEN / NOT BETWEEN
    m.$name ~~ "%moon" || m.$name !~~ "%moon" // LIKE / NOT LIKE
    m.$name ~~* "%moon" || m.$name !~~* "%moon" // ILIKE / NOT ILIKE
    m.$name === "moon" || m.$name !== "moon" // IS / IS NOT
    m.$name === Optional<String>.none
}
```

```sql
WHERE
(("m"."craters" = 3) OR ("m"."craters" != 3)) AND
(("m"."craters" > 3) OR ("m"."craters" < 3)) AND
(("m"."craters" >= 3) OR ("m"."craters" <= 3)) AND
(("m"."craters" IN (3, 4, 5)) OR ("m"."craters" NOT IN (3, 4, 5))) AND
(("m"."craters" BETWEEN 3 AND 5) OR ("m"."craters" NOT BETWEEN 3 AND 5)) AND
(("m"."name" LIKE '%moon') OR ("m"."name" NOT LIKE '%moon')) AND
(("m"."name" ILIKE '%moon') OR ("m"."name" NOT ILIKE '%moon')) AND
(("m"."name" IS 'moon') OR ("m"."name" IS NOT 'moon')) AND
("m"."name" IS NULL)
```

> **Warning** importing custom operators from a package which override something existing has been toubling, you might have to re-declare them in your project see [discussion](https://forums.swift.org/t/exported-import-does-not-properly-export-custom-operators/39090/5)

```swift
infix operator ~~: ComparisonPrecedence
infix operator ...: LogicalConjunctionPrecedence
```

Alternatively, for `...` to create `BETWEEN` you can use `PSQLRange(from: T, to: T)`

#### HAVING

```swift
let m = Moon.as("m")
HAVING {
    AVG(m.$craters) > 1
}
```

```sql
HAVING (AVG("m"."craters") > 1)
```

#### GROUP BY

```swift
let m = Moon.as("m")
GROUPBY {
    m.$name
    m.$craters
    m.$planet
}
```

```sql
GROUP BY "m"."name", "m"."craters", "m"."planet_id"
```

#### ORDER BY

You can append `.asc()`, `.desc()`, or `.order(_ direction: )` to change the direction of the `ORDERBY`. Or leave it blank if you wanna make people guess.

```swift
let m = Moon.as("m")
ORDERBY {
    m.$name
    m.$name.desc()
    m.$craters.asc()
    m.$planet.order(.desc)
}
```

```sql
ORDER BY "m"."name", "m"."name" DESC, "m"."craters" ASC, "m"."planet_id" DESC
```

#### INSERT INTO

```swift
let m = Moon.as("m")
INSERT(into: m.table) {
    m.$name => "the moon"
    m.$craters => 10
    m.$comets => 20
    m.$planet => UUID()
}
```

```sql
INSERT INTO "moons" AS "m" ("name", "craters", "comets", "planet_id") VALUES ('the moon', 10, 20, 'C5C9569B-C1D4-4173-A239-0BBE06602E17')
```

#### UPDATE

```swift
let m = Moon.as("m")
UPDATE(m.table) {
    m.$name => "cool moon"
    m.$craters => 30
}
```

```sql
UPDATE "moons" AS "m" SET "name" = 'cool moon', "craters" = 30
```

#### DELETE FROM

```swift
let m = Moon.as("m")
DELETE { m.table }
```

```sql
DELETE FROM "moons" AS "m"
```

#### QUERY

This object is the main wrapper for a query. It contains sub directives, and can be also nested itself (see `WITH` or `Subquery`)

```swift
let m = Moon.as("m")
QUERY {
    SELECT { m.* }
    FROM { m.table }
}
```

```sql
SELECT "m".* FROM "moons" AS "m"
```

#### WITH

You can next queries and use them in a `WITH` statement. The nested `QUERY` must be annoted with the `.asWith(...)` modifier to allow it in the `WITH` builder

```swift
let m = Moon.as("m")
WITH {
    QUERY {
        SELECT { m.* }
        FROM { m.table }
    }
    .asWith(m.table)
}
```

```sql
WITH "m" AS (SELECT "m".* FROM "moons" AS "m")
```

### Subquery

A `QUERY` can also be nested as a subquery in a `SELECT` or a `FROM`. The nested `QUERY` must be annoted with the `.asSubquery(...)` modifier to allow it in the `SELECT`/`FROM` builder

```swift
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
```

```sql
SELECT (SELECT "m".* FROM "moons" AS "m") AS "x" FROM (SELECT "m".* FROM "moons" AS "m") AS "y"
```

### Arithmetic

The following arithmetic operations have been included:

- `+`
- `-`
- `/`
- `*`

They can also be aliased using `.as(_ alias: String)`

```swift
let m = Moon.as("m")
SELECT {
    m.$craters / m.$comets.as("division")
    m.$craters + m.$comets
    m.$craters - m.$comets
    (m.$craters * m.$comets).as("multiply")
}
```

```sql
SELECT
    ("m"."craters"::INTEGER / "m"."comets"::INTEGER)::NUMERIC AS "division", 
    ("m"."craters"::INTEGER + "m"."comets"::INTEGER)::NUMERIC, 
    ("m"."craters"::INTEGER - "m"."comets"::INTEGER)::NUMERIC, 
    ("m"."craters"::INTEGER * "m"."comets"::INTEGER)::NUMERIC AS "multiply"
```

> Even though you might be using `INTEGER`, because division would cause non integer return I decided to make the psql type of `ArithmeticExpression` be `NUMERIC` always.

Arithmetic will only allow you to compare like types (ie `Int` with an `Int`, or `Double` vs a `Double`) but as an escape hatch you can `transform` one to another type to make compiler happy:

```swift
struct PSQLModel: Table {
    ...
    @Column(key: "age") var age: Int
    @Column(key: "money") var money: Double    
    ...
}

let p = PSQLModel.as("p")
SELECT {
    p.$money / p.$age.transform(to: Double.self)
}
```

### Expressions

The following expressions have been implemented:

- [x] `AVG`
- [x] `MIN`
- [x] `MAX`
- [x] `COUNT`
- [x] `SUM`
- [x] `JSONB_EXTRACT_PATH_TEXT`
- [x] `COALESCE`/`COALESCE3`/`COALESCE4`/`COALESCE5`
- [x] `CONCAT`/`CONCAT3`/`CONCAT4`/`CONCAT5`
- [x] `GENERATE_SERIES`
- [x] `ARRAY_AGG`
- [x] `ARRAY_APPEND`
- [x] `ARRAY_CAT`
- [x] `ARRAY_DIMS`
- [x] `ARRAY_LENGTH`
- [x] `ARRAY_LOWER`
- [x] `ARRAY_NDIMS`
- [x] `ARRAY_PREPEND`
- [x] `ARRAY_REMOVE`
- [x] `ARRAY_REPLACE`
- [x] `ARRAY_TO_STRING`
- [x] `ARRAY_UPPER`

They can also be aliased using `.as(_ alias: String)`

```swift
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
```

```sql
SELECT
    AVG("m"."craters"::INTEGER),
    MIN("m"."craters"::INTEGER),
    MAX("m"."craters"::INTEGER),
    COUNT("m"."craters"::INTEGER) AS "crater_count",
    SUM("m"."craters"::INTEGER),
    COALESCE("m"."craters"::INTEGER, 5::INTEGER) AS "unwrapped_craters",
    CONCAT("m"."name"::TEXT, ' is a cool planet'::TEXT) AS "annotated",
    GENERATE_SERIES(1::INTEGER, 5::INTEGER, 1::INTERVAL)
```

### Advanced

If your types dont match up, you can transform them to another type to make the compiler happy. For example when you want to do date comparisons (which are difficult, see below). Transforms are done using `.transform(to: T.Type)`

```swift
final class MyModel: Model, Table {
    static let schema = "my_model"
    @ID var id: UUID?
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?
}

let m = MyModel.as("m")
QUERY {
    SELECT {
        m.$id
        m.$id.transform(to: Int.self)
        m.$createdAt.as(PSQLDate.self)
    }
    WHERE {
        m.$id.transform(to: Int.self) == 7
        m.$createdAt >< (Date().psqlDate...Date().psqlDate)
    }
}
```

```sql
SELECT "m"."id"::UUID, "m"."id"::INTEGER, "m"."created_at"::DATE WHERE ("m"."id" = 7) AND ("m"."created_at" BETWEEN '2020-10-26'::DATE AND '2020-10-26'::DATE)
```

We want the date to be selected as a `::DATE` to get the formatting `yyyy-MM-dd`. So we needed to tranform the selection to be using `PSQLDate`.

If we wanted to compare a `UUID` against an `Int` (bad example) then we `transform(to: T.Type)`. Then it can be compared against an `Int` in the `WHERE` statement.

### Dates

Dates are tricky. Included are 2 types `PSQLDate` and `PSQLTimestamp` each with have a formatter for serializing for the query (both comform to `PSQLDateTime`). `ColumnExpression where T == Date` have a function `.as<T: PSQLDateTime>(_ psqlDateTimeType: T.Type)` which can transform the column to `::DATE` time or `::TIMESTAMP` formatting.

### Raw

If you want to select a column that is not part of a `Table` use `RawColumn<T>(_ column: String)`. The type is required for annotation in the `SELECT` and for comparisons if you use it in a `WHERE`/`JOIN`/etc. This can also be aliased with `.as(_ alias: String)`

If you want to select a raw value, use the value, provided it conforms to `PSQLExpressible` (conformance for a variety of types has been included). If you want to alias it, you can also use `.as(_ alias: String)`

```swift
SELECT {
    RawColumn<String>("raw_column")
    RawColumn<Int>("raw_column").as("rawer")
    7
    666.as("number_of_the_beast")
}
```

```sql
SELECT "raw_column"::TEXT, "raw_column"::INTEGER AS "rawer", 7::INTEGER, 666::INTEGER AS "number_of_the_beast"
```

### Binding

Dont be vulnerable to SQL injection with user inputted data. You can use `PSQLBind(_ value: T)` to sanitize and bind your variables to the query. Additionaly, you can add the `.asBind()` modifier (sometimes you need to do it with variables to make compiler happy. IDK why but its more safe that way anyways I guess?)

```swift
let m = Moon.as("m")
WHERE {
    m.$name == "the moon".asBind()
    m.$comets > PSQLBind(8)
}
```

```sql
SQL: WHERE ("m"."name" = $1) AND ("m"."comets" > $2)
BINDS: ["the moon", 8]
```

> Binds dont work nice with `PSQLDate` or `PSQLTimestamp`, however they have to be a swift `Date` object at some point so that should escape all injection possibliity from strings there.

### Groupings

Function builders are tricky. There is a lot of boilerplate to retain types but be versatile. All builders support 10 expressions within. If you need more, you can use the group-ers provided. See example and mapping:

```swift
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
```

```sql
SELECT "m"."name"::TEXT, "m"."name"::TEXT, "m"."name"::TEXT
INNER JOIN "planets" AS "p" ON ("p"."id" = "m"."planet_id")
INNER JOIN "planets" AS "p" ON ("p"."id" = "m"."planet_id") AND ("p"."id" = "m"."planet_id")
```

|          | Directive | Group          | Notes                                                                 |
| -------- | --------- | -------------- | --------------------------------------------------------------------- |
| Select   | `SELECT`  | `SELECTGROUP`  |                                                                       |
| Join     | `JOIN`    | `JOINGROUP`    | `JOINGROUP` for the stuff after `ON`, `QUERYGROUP` for multiple joins |
| From     | `FROM`    | `FROMGROUP`    |                                                                       |
| Group By | `GROUPBY` | `GROUPBYGROUP` |                                                                       |
| Having   | `HAVING`  | `HAVINGGROUP`  |                                                                       |
| Order By | `ORDERBY` | `ORDERBYGROUP` |                                                                       |
| Query    | `QUERY`   | `QUERYGROUP`   | All other directives can be in here                                   |
| Where    | `WHERE`   | `WHEREGROUP`   |                                                                       |
| With     | `WITH`    | `WITHGROUP`    |                                                                       |

### Other

Things not mentioned:

Support for custom schema path:
Add optional `static var path: String? { get }` to your model for path support

```swift
final class MyModel: Model, Table {
    static let schema = "my_model"
    static let path: String? = "custom_path"
    @ID var id: UUID?
    @Field(key: "name") var name: String
}
let m = MyModel.as("m")
QUERY {
    SELECT { m.* }
    FROM { m.table }
}
```

```sql
SELECT "m".* FROM "custom_path"."my_model" AS "m"
```

Support for `UNION` (not `UNION ALL` yet):

```swift
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
```

```sql
SELECT "m"."name"::TEXT FROM "moons" AS "m" UNION SELECT "p"."name"::TEXT FROM "planets" AS "p"
```

Support for `DISTINCT` and `DISTINCT ON`

```swift
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
```

```sql
WITH "x" AS (SELECT DISTINCT ON ("m"."name"::TEXT, "m"."id"::UUID) "m"."name"::TEXT), "y" AS (SELECT DISTINCT "p"."name"::TEXT, "p"."id"::UUID)
```

> I know this example makes no sense but its hard to make an example without setting up a ton of context

## Not using Fluent?

If you are not using models that conform to `Model` from `Fluent`/`FluentKit`, you can still use this library... although it might not have as many features. Like above, still conform your models to `Table`. From here you will have access to some property wrappers similar to `@ID`/`@Field`/`@OptionalField`. This can be useful for intermediate query tables if you use the `WITH` psql feature. They are listed below along with their use in comparison to `Fluent` wrappers.

| `X: Model, Table`                                            | `X: Table`                                              | Notes                                 |
| ------------------------------------------------------------ | ------------------------------------------------------- | ------------------------------------- |
| `@ID var id: UUID?`                                          | `@Column(key: "id") var id: UUID?`                      |                                       |
| `@Field(key: "name") var name: String`                       | `@Column(key: "name") var name: String`                 |                                       |
| `@OptionalField(key: "name") var name: String`               | `@OptionalColumn(key: "name") var name: String`         |                                       |
| `@Parent(key: "parent_id") var parent: ParentModel`          | `@Column(key: "parent_id") var parentId: UUID`          | Foreign keys without `Fluent`         |
| `@OptionalParent(key: "parent_id") var parent: ParentModel?` | `@OptionalColumn(key: "parent_id") var parentId: UUID?` | Foreign keys without `Fluent`         |
| `@Group(key: "group") var group: Group`                      | `@NestedColumn(key: "group") var group: Group`          | `Group: TableObject` without `Fluent` |

Example without `Model` conformance

```swift
public struct Moon: Table {
    public static let schema = "moons"

    @Column(key: "id") public var id: UUID?
    @Column(key: "name") public var name: String
    @Column(key: "craters") public var craters: Int
    @Column(key: "comets") public var comets: Int
    @Column(key: "planet_id") public var planet: Planet

    ...
}
```

You can do most of the same stuff as above!

## Advanced Example

Heres a contrived advanced example. There's lots of tests, you can also check for functionality there.

```swift
final class Pet: Model, Table {
    static let schema = "pet"

    @ID var id: UUID?
    @Field(key: "name") var name: String
    @Parent(key: "owner_id") var owner: Owner

    init() {}
}

final class Owner: Model, Table {
    static let schema = "owner"

    @ID var id: UUID?
    @Field(key: "name") var name: String
    @Field(key: "age") var age: Int
    @Field(key: "bday") var bday: PSQLDate

    init() {}
}

struct DateRange: Table {
    static let schema: String = "date_range"
    @Column(key: "date") var date: PSQLDate
}

struct OwnerFilter: Table {
    @Column(key: "id") var id: UUID
}

struct OwnerDateSeries: Table {
    @OptionalColumn(key: "id") var id: UUID?
    @Column(key: "date") var date: PSQLDate
}

let d1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 31).date!
let d2 = DateComponents(calendar: .current, year: 2020, month: 07, day: 31).date!
let r = DateRange.as("r")
let dateCol = RawColumn<PSQLDate>("date")
let p = Pet.as("p")
let o = Owner.as("o")
let f = OwnerFilter.as("f")

QUERY {
    WITH {
        QUERY {
            SELECT { dateCol }
            FROM { GENERATE_SERIES(from: PSQLBind(d1.psqlDate), to: d2.psqlDate.asBind(), interval: "1 day") }
            ORDERBY { dateCol }
        }
        .asWith(r.table) // access the results from this query using r.$...
        QUERY {
            SELECT { o.$id }.distinct()
            FROM { p.table }
            JOIN(o.table) { o.$id == p.$owner }
            WHERE {
                o.$age > 20
                p.$name == "dog"
            }
        }
        .asWith(f.table) // access the results from this query using f.$...
        QUERY {
            SELECT {
                r.$date
                f.$id
            }
            FROM { f.table }
            JOIN(r.table) { true }
        }
        .asWith(OwnerDateSeries.table) // not using alias to access results with full type...
    }

    SELECT {
        OwnerDateSeries.$date
        o.$name
    }
    FROM { f.table }
    JOIN(o.table, method: .left) { f.$id == o.$id }
    JOIN(OwnerDateSeries.table) { o.$bday == OwnerDateSeries.$date }
}
```

```sql
WITH
"r" AS (
    SELECT "date"::DATE
    FROM GENERATE_SERIES($1, $2, '1 day'::INTERVAL)
    ORDER BY "date"
),
"f" AS (
    SELECT DISTINCT "o"."id"::UUID
    FROM "pet" AS "p"
    INNER JOIN "owner" AS "o" ON ("o"."id" = "p"."owner_id")
    WHERE ("o"."age" > 20) AND ("p"."name" = 'dog')
),
"OwnerDateSeries" AS (
    SELECT "r"."date"::DATE, "f"."id"::UUID
    FROM "OwnerFilter" AS "f"
    INNER JOIN "date_range" AS "r" ON true
)
SELECT "OwnerDateSeries"."date"::DATE, "o"."name"::TEXT
FROM "OwnerFilter" AS "f"
LEFT JOIN "owner" AS "o" ON ("f"."id" = "o"."id")
INNER JOIN "OwnerDateSeries" ON ("o"."bday" = "OwnerDateSeries"."date")
```

## Todo

Hopefully people smarter than me (most people) are interested in adding features to this package, and helping make things more elegant. PR's with new functionality, or fixing bugs/dumb stuff I did is welcome.

- [ ] JSON/JSONB functions (and maybe operators)
- [ ] PARTITION BY
- [ ] Better function builders
- [ ] SELECT ROW_NUMBER() OVER (...)
- [ ] Add `ESCAPE` to `LIKE/ILIKE/ETC`
- [ ] Add `ALL` to `UNION` (and probable change the way `UNION` works)
