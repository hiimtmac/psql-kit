// ExpressionTests.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import SQLKit
import Testing
import PSQLKit

@Suite
struct ExpressionTests {
    let p = PSQLModel.as("x")

    @Test
    func testMax() {
        var serializer = SQLSerializer.test

        SELECT {
            MAX(p.$name)
            MAX(p.$age).as("age")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT MAX("x"."name"::TEXT), MAX("x"."age"::INTEGER) AS "age""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testMin() {
        var serializer = SQLSerializer.test

        SELECT {
            MIN(p.$name)
            MIN(p.$age).as("age")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT MIN("x"."name"::TEXT), MIN("x"."age"::INTEGER) AS "age""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testCount() {
        var serializer = SQLSerializer.test

        SELECT {
            COUNT(p.$name)
            COUNT(p.$age).as("age")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT COUNT("x"."name"::TEXT), COUNT("x"."age"::INTEGER) AS "age""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testCountDistinct() {
        var serializer = SQLSerializer.test

        SELECT {
            COUNT(p.$name)
                .distinct()
            COUNT(p.$age)
                .distinct()
                .as("age")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT COUNT(DISTINCT "x"."name"::TEXT), COUNT(DISTINCT "x"."age"::INTEGER) AS "age""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testSum() {
        var serializer = SQLSerializer.test

        SELECT {
            SUM(p.$name)
            SUM(p.$age).as("age")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT SUM("x"."name"::TEXT), SUM("x"."age"::INTEGER) AS "age""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testGenerateSeries() {
        var serializer = SQLSerializer.test

        let date1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!.psqlDate
        let date2 = DateComponents(calendar: .current, year: 2020, month: 01, day: 30).date!.psqlDate

        SELECT {
            GENERATE_SERIES(from: 8, to: 20, interval: 10)
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT GENERATE_SERIES(8::INTEGER, 20::INTEGER, 10::INTERVAL), GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL) AS "dates""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testConcat() {
        var serializer = SQLSerializer.test

        SELECT {
            CONCAT(p.$name, " ", p.$title, " ", p.$name)
            CONCAT(p.$name, " ", p.$title, " ").as("cool")
            CONCAT(p.$name, " ", p.$title)
            CONCAT(8, 8).as("cool")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT CONCAT("x"."name", ' ', "x"."title", ' ', "x"."name")::TEXT, CONCAT("x"."name", ' ', "x"."title", ' ')::TEXT AS "cool", CONCAT("x"."name", ' ', "x"."title")::TEXT, CONCAT(8, 8)::TEXT AS "cool""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testCoalesce() {
        var serializer = SQLSerializer.test

        SELECT {
            COALESCE(p.$name, p.$name, p.$name, p.$name, "hello").as("cool")
            COALESCE(p.$name, p.$name, p.$name, "hello").as("cool")
            COALESCE(p.$name, p.$name, "hello").as("cool")
            COALESCE(p.$name, "hello").as("cool")
            COALESCE(p.$name, COALESCE(p.$name, "hello"))
        }
        .serialize(to: &serializer)

        let compare = #"SELECT COALESCE("x"."name", "x"."name", "x"."name", "x"."name", 'hello')::TEXT AS "cool", COALESCE("x"."name", "x"."name", "x"."name", 'hello')::TEXT AS "cool", COALESCE("x"."name", "x"."name", 'hello')::TEXT AS "cool", COALESCE("x"."name", 'hello')::TEXT AS "cool", COALESCE("x"."name", COALESCE("x"."name", 'hello'))::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testCoalesceCompare() {
        var serializer = SQLSerializer.test

        let date = DateComponents(calendar: .current, year: 2021, month: 01, day: 21).date!

        WHERE {
            COALESCE(p.$name, "tmac") == "taylor"
            COALESCE(p.$birthday, date.psqlDate) >< PSQLRange(from: date.psqlDate, to: date.psqlDate)
        }
        .serialize(to: &serializer)

        let compare = #"WHERE (COALESCE("x"."name", 'tmac') = 'taylor') AND (COALESCE("x"."birthday", '2021-01-21') BETWEEN '2021-01-21' AND '2021-01-21')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testConcatCompare() {
        var serializer = SQLSerializer.test

        WHERE {
            CONCAT(p.$name, "tmac") == "taylor"
        }
        .serialize(to: &serializer)

        let compare = #"WHERE (CONCAT("x"."name", 'tmac') = 'taylor')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayAggregate() {
        var serializer = SQLSerializer.test

        SELECT {
            ARRAY_AGG(p.$name).as("agg")
            ARRAY_AGG(PSQLArray([1, 2, 3])).as("array")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ARRAY_AGG("x"."name"::TEXT) AS "agg", ARRAY_AGG(ARRAY[1, 2, 3]::INTEGER[]) AS "array""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayToString() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT {
                ARRAY_TO_STRING(p.$name, delimiter: ",", ifNull: "*")
                ARRAY_TO_STRING(p.$name, delimiter: ",").as("agg")
                ARRAY_TO_STRING(PSQLArray([1, 2, 3]), delimiter: ",").as("array")
            }
            WHERE {
                ARRAY_TO_STRING(p.$name, delimiter: ",") == "taylor, tmac"
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ARRAY_TO_STRING("x"."name"::TEXT, ',', '*')::TEXT, ARRAY_TO_STRING("x"."name"::TEXT, ',')::TEXT AS "agg", ARRAY_TO_STRING(ARRAY[1, 2, 3]::INTEGER[], ',')::TEXT AS "array" WHERE (ARRAY_TO_STRING("x"."name", ',') = 'taylor, tmac')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayUpper() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT {
                ARRAY_UPPER(p.$name, dimension: 1).as("upp")
                ARRAY_UPPER(PSQLArray([1, 2, 3]), dimension: 1).as("upp")
            }
            WHERE {
                ARRAY_UPPER(p.$name, dimension: 1) == 5
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ARRAY_UPPER("x"."name"::TEXT, 1)::INTEGER AS "upp", ARRAY_UPPER(ARRAY[1, 2, 3]::INTEGER[], 1)::INTEGER AS "upp" WHERE (ARRAY_UPPER("x"."name", 1) = 5)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayNDims() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT {
                ARRAY_NDIMS(p.$name).as("upp")
                ARRAY_NDIMS(PSQLArray([1, 2, 3]))
            }
            WHERE {
                ARRAY_NDIMS(p.$name) == 5
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ARRAY_NDIMS("x"."name"::TEXT)::INTEGER AS "upp", ARRAY_NDIMS(ARRAY[1, 2, 3]::INTEGER[])::INTEGER WHERE (ARRAY_NDIMS("x"."name") = 5)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayLower() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT {
                ARRAY_LOWER(p.$name, dimension: 1).as("low")
                ARRAY_LOWER(PSQLArray([1, 2, 3]), dimension: 1).as("low")
            }
            WHERE {
                ARRAY_LOWER(p.$name, dimension: 1) == 5
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ARRAY_LOWER("x"."name"::TEXT, 1)::INTEGER AS "low", ARRAY_LOWER(ARRAY[1, 2, 3]::INTEGER[], 1)::INTEGER AS "low" WHERE (ARRAY_LOWER("x"."name", 1) = 5)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayLength() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT {
                ARRAY_LENGTH(p.$name, dimension: 1).as("low")
                ARRAY_LENGTH(PSQLArray([1, 2, 3]), dimension: 1).as("low")
            }
            WHERE {
                ARRAY_LENGTH(p.$name, dimension: 1) == 5
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ARRAY_LENGTH("x"."name"::TEXT, 1)::INTEGER AS "low", ARRAY_LENGTH(ARRAY[1, 2, 3]::INTEGER[], 1)::INTEGER AS "low" WHERE (ARRAY_LENGTH("x"."name", 1) = 5)"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayDims() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT {
                ARRAY_DIMS(p.$name).as("dim")
                ARRAY_DIMS(PSQLArray([1, 2, 3]))
            }
            WHERE {
                ARRAY_DIMS(p.$name) == "[5]"
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ARRAY_DIMS("x"."name"::TEXT)::TEXT AS "dim", ARRAY_DIMS(ARRAY[1, 2, 3]::INTEGER[])::TEXT WHERE (ARRAY_DIMS("x"."name") = '[5]')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayReplace() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT {
                ARRAY_REPLACE(p.$name, find: "hi", replace: "bye").as("rep")
                ARRAY_REPLACE(PSQLArray([1, 2, 3]), find: 1, replace: 2)
            }
            WHERE {
                ARRAY_REPLACE(p.$name, find: "hi", replace: "by") == ["hello"]
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ARRAY_REPLACE("x"."name"::TEXT, 'hi'::TEXT, 'bye'::TEXT)::TEXT[] AS "rep", ARRAY_REPLACE(ARRAY[1, 2, 3]::INTEGER[], 1::INTEGER, 2::INTEGER)::INTEGER[] WHERE (ARRAY_REPLACE("x"."name", 'hi', 'by') = ('hello'))"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayRemove() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT {
                ARRAY_REMOVE(p.$name, remove: "hi").as("rep")
                ARRAY_REMOVE(PSQLArray([1, 2, 3]), remove: 1)
            }
            WHERE {
                ARRAY_REMOVE(p.$name, remove: "hi") == ["hello"]
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ARRAY_REMOVE("x"."name"::TEXT, 'hi'::TEXT)::TEXT[] AS "rep", ARRAY_REMOVE(ARRAY[1, 2, 3]::INTEGER[], 1::INTEGER)::INTEGER[] WHERE (ARRAY_REMOVE("x"."name", 'hi') = ('hello'))"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayPrepend() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT {
                ARRAY_PREPEND(p.$name, prepend: "hi").as("pre")
                ARRAY_PREPEND(PSQLArray([1, 2, 3]), prepend: 1)
            }
            WHERE {
                ARRAY_PREPEND(p.$name, prepend: "hi") == ["hello"]
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ARRAY_PREPEND('hi'::TEXT, "x"."name"::TEXT)::TEXT[] AS "pre", ARRAY_PREPEND(1::INTEGER, ARRAY[1, 2, 3]::INTEGER[])::INTEGER[] WHERE (ARRAY_PREPEND('hi', "x"."name") = ('hello'))"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayConcatenate() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT {
                ARRAY_CAT(p.$name, p.$name).as("app")
                ARRAY_CAT(PSQLArray([1, 2, 3]), PSQLArray([1, 2, 3]))
            }
            WHERE {
                ARRAY_CAT(p.$name, PSQLArray(["hi"])) == ["hello"]
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ARRAY_CAT("x"."name"::TEXT, "x"."name"::TEXT)::TEXT[] AS "app", ARRAY_CAT(ARRAY[1, 2, 3]::INTEGER[], ARRAY[1, 2, 3]::INTEGER[])::INTEGER[] WHERE (ARRAY_CAT("x"."name", ARRAY['hi']) = ('hello'))"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayAppend() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT {
                ARRAY_APPEND(p.$name, append: "hi").as("app")
                ARRAY_APPEND(PSQLArray([1, 2, 3]), append: 1)
            }
            WHERE {
                ARRAY_APPEND(p.$name, append: "hi") == ["hello"]
            }
        }
        .serialize(to: &serializer)

        let compare = #"SELECT ARRAY_APPEND("x"."name"::TEXT, 'hi'::TEXT)::TEXT[] AS "app", ARRAY_APPEND(ARRAY[1, 2, 3]::INTEGER[], 1::INTEGER)::INTEGER[] WHERE (ARRAY_APPEND("x"."name", 'hi') = ('hello'))"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testConcateWithCoalesce() {
        var serializer = SQLSerializer.test

        SELECT {
            CONCAT(COALESCE(p.$name, "hi"), " there")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT CONCAT(COALESCE("x"."name", 'hi'), ' there')::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testDateTrunc() {
        var serializer = SQLSerializer.test

        SELECT {
            DATE_TRUNC("hour", p.$birthday).as("datehour")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT DATE_TRUNC('hour', "x"."birthday"::TIMESTAMP) AS "datehour""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testDatePart() {
        var serializer = SQLSerializer.test

        SELECT {
            DATE_PART("hour", p.$birthday).as("hour")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT DATE_PART('hour', "x"."birthday"::TIMESTAMP) AS "hour""#
        #expect(serializer.sql == compare)
    }
    
    @Test
    func testCrosstab() {
        var serializer = SQLSerializer.test

        QUERY {
            SELECT(.all)
            FROM {
                CROSSTAB([
                    ColumnDefinition(p.$title),
                    ColumnDefinition("Jan", type: Int.self),
                    ColumnDefinition("Feb", type: Int.self),
                    ColumnDefinition("Mar", type: Int.self),
                    ColumnDefinition("Apr", type: Int.self)
                ]) {
                    SELECT {
                        p.$title
                        p.$age
                        p.$money
                    }
                    FROM(p.table)
                    ORDERBY { 1 }
                } category: {
                    SELECT { GENERATE_SERIES(from: 1, to: 4, interval: 1).as("months") }
                }
            }
        }
        .serialize(to: &serializer)

        let source = [
            #"SELECT "x"."title"::TEXT, "x"."age"::INTEGER, "x"."money"::NUMERIC"#,
            #"FROM "my_model" AS "x""#,
            #"ORDER BY 1"#
        ].joined(separator: " ")
        
        let category = [
            #"SELECT GENERATE_SERIES(1::INTEGER, 4::INTEGER, 1::INTERVAL) AS "months""#
        ].joined(separator: " ")
        
        let record = [
            #""title" TEXT"#,
            #""Jan" INTEGER"#,
            #""Feb" INTEGER"#,
            #""Mar" INTEGER"#,
            #""Apr" INTEGER"#
        ].joined(separator: ", ")
        
        let compare = [
            #"SELECT * FROM"#,
            #"CROSSTAB('\#(source)', '\#(category)') AS (\#(record))"#
        ].joined(separator: " ")

        #expect(serializer.sql == compare)
    }
}
