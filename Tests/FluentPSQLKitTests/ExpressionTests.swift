// ExpressionTests.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import SQLKit
import Testing
@testable import FluentPSQLKit

@Suite
struct ExpressionTests {
    let f = FluentModel.as("x")

    @Test
    func testMax() {
        var serializer = SQLSerializer.test
        SELECT {
            MAX(f.$name)
            MAX(f.$age).as("age")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT MAX("x"."name"::TEXT), MAX("x"."age"::INTEGER) AS "age""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testMin() {
        var serializer = SQLSerializer.test
        SELECT {
            MIN(f.$name)
            MIN(f.$age).as("age")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT MIN("x"."name"::TEXT), MIN("x"."age"::INTEGER) AS "age""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testCount() {
        var serializer = SQLSerializer.test
        SELECT {
            COUNT(f.$name)
            COUNT(f.$age).as("age")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT COUNT("x"."name"::TEXT), COUNT("x"."age"::INTEGER) AS "age""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testCountDistinct() {
        var serializer = SQLSerializer.test
        SELECT {
            COUNT(f.$name)
                .distinct()
            COUNT(f.$age)
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
            SUM(f.$name)
            SUM(f.$age).as("age")
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
            CONCAT(f.$name, " ", f.$title, " ", f.$name)
            CONCAT(f.$name, " ", f.$title, " ").as("cool")
            CONCAT(f.$name, " ", f.$title)
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
            COALESCE(f.$name, f.$name, f.$name, f.$name, "hello").as("cool")
            COALESCE(f.$name, f.$name, f.$name, "hello").as("cool")
            COALESCE(f.$name, f.$name, "hello").as("cool")
            COALESCE(f.$name, "hello").as("cool")
            COALESCE(f.$name, COALESCE(f.$name, "hello"))
        }
        .serialize(to: &serializer)

        let compare = #"SELECT COALESCE("x"."name", "x"."name", "x"."name", "x"."name", 'hello')::TEXT AS "cool", COALESCE("x"."name", "x"."name", "x"."name", 'hello')::TEXT AS "cool", COALESCE("x"."name", "x"."name", 'hello')::TEXT AS "cool", COALESCE("x"."name", 'hello')::TEXT AS "cool", COALESCE("x"."name", COALESCE("x"."name", 'hello'))::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testJsonExtractPathText() {
        var serializer = SQLSerializer.test
        SELECT {
            JSONB_EXTRACT_PATH_TEXT(f.$pet, "hello").as("cool")
            JSONB_EXTRACT_PATH_TEXT(f.$pet, "hello", "cool")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'hello')::TEXT AS "cool", JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'hello', 'cool')::TEXT"#
        #expect(serializer.sql == compare)
    }
    
    @Test
    func testJsonExtractPath() {
        var serializer = SQLSerializer.test
        SELECT {
            JSONB_EXTRACT_PATH(f.$pet, "hello", as: String.self).as("cool")
            JSONB_EXTRACT_PATH(f.$pet, "hello", "cool", as: String.self)
        }
        .serialize(to: &serializer)

        let compare = #"SELECT JSONB_EXTRACT_PATH("x"."pet"::JSONB, 'hello')::TEXT AS "cool", JSONB_EXTRACT_PATH("x"."pet"::JSONB, 'hello', 'cool')::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testNestedJsonExtract() {
        var serializer = SQLSerializer.test
        SELECT {
            COALESCE(
                JSONB_EXTRACT_PATH_TEXT(f.$pet, \.$name),
                JSONB_EXTRACT_PATH_TEXT(f.$pet, \.$type)
            )
        }
        .serialize(to: &serializer)

        let compare = #"SELECT COALESCE(JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'name'), JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'type'))::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testCoalesceCompare() {
        var serializer = SQLSerializer.test
        let date = DateComponents(calendar: .current, year: 2021, month: 01, day: 21).date!

        WHERE {
            COALESCE(f.$name, "tmac") == "taylor"
            COALESCE(f.$birthday, date.psqlDate) >< PSQLRange(from: date.psqlDate, to: date.psqlDate)
        }
        .serialize(to: &serializer)

        let compare = #"WHERE (COALESCE("x"."name", 'tmac') = 'taylor') AND (COALESCE("x"."birthday", '2021-01-21') BETWEEN '2021-01-21' AND '2021-01-21')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testConcatCompare() {
        var serializer = SQLSerializer.test
        WHERE {
            CONCAT(f.$name, "tmac") == "taylor"
        }
        .serialize(to: &serializer)

        let compare = #"WHERE (CONCAT("x"."name", 'tmac') = 'taylor')"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testArrayAggregate() {
        var serializer = SQLSerializer.test
        SELECT {
            ARRAY_AGG(f.$name).as("agg")
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
                ARRAY_TO_STRING(f.$name, delimiter: ",", ifNull: "*")
                ARRAY_TO_STRING(f.$name, delimiter: ",").as("agg")
                ARRAY_TO_STRING(PSQLArray([1, 2, 3]), delimiter: ",").as("array")
            }
            WHERE {
                ARRAY_TO_STRING(f.$name, delimiter: ",") == "taylor, tmac"
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
                ARRAY_UPPER(f.$name, dimension: 1).as("upp")
                ARRAY_UPPER(PSQLArray([1, 2, 3]), dimension: 1).as("upp")
            }
            WHERE {
                ARRAY_UPPER(f.$name, dimension: 1) == 5
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
                ARRAY_NDIMS(f.$name).as("upp")
                ARRAY_NDIMS(PSQLArray([1, 2, 3]))
            }
            WHERE {
                ARRAY_NDIMS(f.$name) == 5
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
                ARRAY_LOWER(f.$name, dimension: 1).as("low")
                ARRAY_LOWER(PSQLArray([1, 2, 3]), dimension: 1).as("low")
            }
            WHERE {
                ARRAY_LOWER(f.$name, dimension: 1) == 5
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
                ARRAY_LENGTH(f.$name, dimension: 1).as("low")
                ARRAY_LENGTH(PSQLArray([1, 2, 3]), dimension: 1).as("low")
            }
            WHERE {
                ARRAY_LENGTH(f.$name, dimension: 1) == 5
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
                ARRAY_DIMS(f.$name).as("dim")
                ARRAY_DIMS(PSQLArray([1, 2, 3]))
            }
            WHERE {
                ARRAY_DIMS(f.$name) == "[5]"
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
                ARRAY_REPLACE(f.$name, find: "hi", replace: "bye").as("rep")
                ARRAY_REPLACE(PSQLArray([1, 2, 3]), find: 1, replace: 2)
            }
            WHERE {
                ARRAY_REPLACE(f.$name, find: "hi", replace: "by") == ["hello"]
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
                ARRAY_REMOVE(f.$name, remove: "hi").as("rep")
                ARRAY_REMOVE(PSQLArray([1, 2, 3]), remove: 1)
            }
            WHERE {
                ARRAY_REMOVE(f.$name, remove: "hi") == ["hello"]
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
                ARRAY_PREPEND(f.$name, prepend: "hi").as("pre")
                ARRAY_PREPEND(PSQLArray([1, 2, 3]), prepend: 1)
            }
            WHERE {
                ARRAY_PREPEND(f.$name, prepend: "hi") == ["hello"]
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
                ARRAY_CAT(f.$name, f.$name).as("app")
                ARRAY_CAT(PSQLArray([1, 2, 3]), PSQLArray([1, 2, 3]))
            }
            WHERE {
                ARRAY_CAT(f.$name, PSQLArray(["hi"])) == ["hello"]
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
                ARRAY_APPEND(f.$name, append: "hi").as("app")
                ARRAY_APPEND(PSQLArray([1, 2, 3]), append: 1)
            }
            WHERE {
                ARRAY_APPEND(f.$name, append: "hi") == ["hello"]
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
            CONCAT(COALESCE(f.$name, "hi"), " there")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT CONCAT(COALESCE("x"."name", 'hi'), ' there')::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testDateTrunc() {
        var serializer = SQLSerializer.test
        SELECT {
            DATE_TRUNC("hour", f.$birthday).as("datehour")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT DATE_TRUNC('hour', "x"."birthday"::TIMESTAMP) AS "datehour""#
        #expect(serializer.sql == compare)
    }

    @Test
    func testDatePart() {
        var serializer = SQLSerializer.test
        SELECT {
            DATE_PART("hour", f.$birthday).as("hour")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT DATE_PART('hour', "x"."birthday"::TIMESTAMP) AS "hour""#
        #expect(serializer.sql == compare)
    }
}
