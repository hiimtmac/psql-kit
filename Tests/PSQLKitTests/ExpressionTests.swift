// ExpressionTests.swift
// Copyright © 2022 hiimtmac

import XCTest
@testable import PSQLKit

final class ExpressionTests: PSQLTestCase {
    let f = FluentModel.as("x")
    let p = PSQLModel.as("x")

    func testMax() {
        SELECT {
            MAX(f.$name)
            MAX(f.$age).as("age")
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            MAX(p.$name)
            MAX(p.$age).as("age")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT MAX("x"."name"::TEXT), MAX("x"."age"::INTEGER) AS "age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testMin() {
        SELECT {
            MIN(f.$name)
            MIN(f.$age).as("age")
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            MIN(p.$name)
            MIN(p.$age).as("age")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT MIN("x"."name"::TEXT), MIN("x"."age"::INTEGER) AS "age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testCount() {
        SELECT {
            COUNT(f.$name)
            COUNT(f.$age).as("age")
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            COUNT(p.$name)
            COUNT(p.$age).as("age")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT COUNT("x"."name"::TEXT), COUNT("x"."age"::INTEGER) AS "age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testCountDistinct() {
        SELECT {
            COUNT(f.$name)
                .distinct()
            COUNT(f.$age)
                .distinct()
                .as("age")
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            COUNT(p.$name)
                .distinct()
            COUNT(p.$age)
                .distinct()
                .as("age")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT COUNT(DISTINCT "x"."name"::TEXT), COUNT(DISTINCT "x"."age"::INTEGER) AS "age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testSum() {
        SELECT {
            SUM(f.$name)
            SUM(f.$age).as("age")
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            SUM(p.$name)
            SUM(p.$age).as("age")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT SUM("x"."name"::TEXT), SUM("x"."age"::INTEGER) AS "age""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testGenerateSeries() {
        let date1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!.psqlDate
        let date2 = DateComponents(calendar: .current, year: 2020, month: 01, day: 30).date!.psqlDate

        SELECT {
            GENERATE_SERIES(from: 8, to: 20, interval: 10)
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            GENERATE_SERIES(from: 8, to: 20, interval: 10)
            GENERATE_SERIES(from: date1, to: date2, interval: "1 day").as("dates")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT GENERATE_SERIES(8::INTEGER, 20::INTEGER, 10::INTERVAL), GENERATE_SERIES('2020-01-01'::DATE, '2020-01-30'::DATE, '1 day'::INTERVAL) AS "dates""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testConcat() {
        SELECT {
            CONCAT(f.$name, " ", f.$title, " ", f.$name)
            CONCAT(f.$name, " ", f.$title, " ").as("cool")
            CONCAT(f.$name, " ", f.$title)
            CONCAT(8, 8).as("cool")
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            CONCAT(p.$name, " ", p.$title, " ", p.$name)
            CONCAT(p.$name, " ", p.$title, " ").as("cool")
            CONCAT(p.$name, " ", p.$title)
            CONCAT(8, 8).as("cool")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT CONCAT("x"."name", ' ', "x"."title", ' ', "x"."name")::TEXT, CONCAT("x"."name", ' ', "x"."title", ' ')::TEXT AS "cool", CONCAT("x"."name", ' ', "x"."title")::TEXT, CONCAT(8, 8)::TEXT AS "cool""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testCoalesce() {
        SELECT {
            COALESCE(f.$name, f.$name, f.$name, f.$name, "hello").as("cool")
            COALESCE(f.$name, f.$name, f.$name, "hello").as("cool")
            COALESCE(f.$name, f.$name, "hello").as("cool")
            COALESCE(f.$name, "hello").as("cool")
            COALESCE(f.$name, COALESCE(f.$name, "hello"))
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            COALESCE(p.$name, p.$name, p.$name, p.$name, "hello").as("cool")
            COALESCE(p.$name, p.$name, p.$name, "hello").as("cool")
            COALESCE(p.$name, p.$name, "hello").as("cool")
            COALESCE(p.$name, "hello").as("cool")
            COALESCE(p.$name, COALESCE(f.$name, "hello"))
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT COALESCE("x"."name", "x"."name", "x"."name", "x"."name", 'hello')::TEXT AS "cool", COALESCE("x"."name", "x"."name", "x"."name", 'hello')::TEXT AS "cool", COALESCE("x"."name", "x"."name", 'hello')::TEXT AS "cool", COALESCE("x"."name", 'hello')::TEXT AS "cool", COALESCE("x"."name", COALESCE("x"."name", 'hello'))::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testJsonExtractPathText() {
        SELECT {
            JSONB_EXTRACT_PATH_TEXT(f.$pet, "hello", as: String.self).as("cool")
            JSONB_EXTRACT_PATH_TEXT(f.$pet, "hello", "cool", as: String.self)
        }
        .serialize(to: &fluentSerializer)
        SELECT {
            JSONB_EXTRACT_PATH_TEXT(p.$pet, "hello", as: String.self).as("cool")
            JSONB_EXTRACT_PATH_TEXT(p.$pet, "hello", "cool", as: String.self)
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT JSONB_EXTRACT_PATH_TEXT("x"."pet", 'hello')::TEXT AS "cool", JSONB_EXTRACT_PATH_TEXT("x"."pet", 'hello', 'cool')::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testNestedJsonExtract() {
        SELECT {
            COALESCE(
                JSONB_EXTRACT_PATH_TEXT(f.$pet, \.$name),
                JSONB_EXTRACT_PATH_TEXT(f.$pet, \.$type)
            )
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            COALESCE(
                JSONB_EXTRACT_PATH_TEXT(p.$pet, \.$name),
                JSONB_EXTRACT_PATH_TEXT(p.$pet, \.$type)
            )
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT COALESCE(JSONB_EXTRACT_PATH_TEXT("x"."pet", 'name'), JSONB_EXTRACT_PATH_TEXT("x"."pet", 'type'))::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testCoalesceCompare() {
        let date = DateComponents(calendar: .current, year: 2021, month: 01, day: 21).date!

        WHERE {
            COALESCE(f.$name, "tmac") == "taylor"
            COALESCE(f.$birthday, date.psqlDate) >< PSQLRange(from: date.psqlDate, to: date.psqlDate)
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            COALESCE(p.$name, "tmac") == "taylor"
            COALESCE(p.$birthday, date.psqlDate) >< PSQLRange(from: date.psqlDate, to: date.psqlDate)
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE (COALESCE("x"."name", 'tmac') = 'taylor') AND (COALESCE("x"."birthday", '2021-01-21') BETWEEN '2021-01-21' AND '2021-01-21')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testConcatCompare() {
        WHERE {
            CONCAT(f.$name, "tmac") == "taylor"
        }
        .serialize(to: &fluentSerializer)

        WHERE {
            CONCAT(p.$name, "tmac") == "taylor"
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"WHERE (CONCAT("x"."name", 'tmac') = 'taylor')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testArrayAggregate() {
        SELECT {
            ARRAY_AGG(f.$name).as("agg")
            ARRAY_AGG(PSQLArray([1, 2, 3])).as("array")
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            ARRAY_AGG(p.$name).as("agg")
            ARRAY_AGG(PSQLArray([1, 2, 3])).as("array")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ARRAY_AGG("x"."name"::TEXT) AS "agg", ARRAY_AGG(ARRAY[1, 2, 3]::INTEGER[]) AS "array""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testArrayToString() {
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
        .serialize(to: &fluentSerializer)

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
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ARRAY_TO_STRING("x"."name"::TEXT, ',', '*')::TEXT, ARRAY_TO_STRING("x"."name"::TEXT, ',')::TEXT AS "agg", ARRAY_TO_STRING(ARRAY[1, 2, 3]::INTEGER[], ',')::TEXT AS "array" WHERE (ARRAY_TO_STRING("x"."name", ',') = 'taylor, tmac')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testArrayUpper() {
        QUERY {
            SELECT {
                ARRAY_UPPER(f.$name, dimension: 1).as("upp")
                ARRAY_UPPER(PSQLArray([1, 2, 3]), dimension: 1).as("upp")
            }
            WHERE {
                ARRAY_UPPER(f.$name, dimension: 1) == 5
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT {
                ARRAY_UPPER(p.$name, dimension: 1).as("upp")
                ARRAY_UPPER(PSQLArray([1, 2, 3]), dimension: 1).as("upp")
            }
            WHERE {
                ARRAY_UPPER(p.$name, dimension: 1) == 5
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ARRAY_UPPER("x"."name"::TEXT, 1)::INTEGER AS "upp", ARRAY_UPPER(ARRAY[1, 2, 3]::INTEGER[], 1)::INTEGER AS "upp" WHERE (ARRAY_UPPER("x"."name", 1) = 5)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testArrayNDims() {
        QUERY {
            SELECT {
                ARRAY_NDIMS(f.$name).as("upp")
                ARRAY_NDIMS(PSQLArray([1, 2, 3]))
            }
            WHERE {
                ARRAY_NDIMS(f.$name) == 5
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT {
                ARRAY_NDIMS(p.$name).as("upp")
                ARRAY_NDIMS(PSQLArray([1, 2, 3]))
            }
            WHERE {
                ARRAY_NDIMS(p.$name) == 5
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ARRAY_NDIMS("x"."name"::TEXT)::INTEGER AS "upp", ARRAY_NDIMS(ARRAY[1, 2, 3]::INTEGER[])::INTEGER WHERE (ARRAY_NDIMS("x"."name") = 5)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testArrayLower() {
        QUERY {
            SELECT {
                ARRAY_LOWER(f.$name, dimension: 1).as("low")
                ARRAY_LOWER(PSQLArray([1, 2, 3]), dimension: 1).as("low")
            }
            WHERE {
                ARRAY_LOWER(f.$name, dimension: 1) == 5
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT {
                ARRAY_LOWER(p.$name, dimension: 1).as("low")
                ARRAY_LOWER(PSQLArray([1, 2, 3]), dimension: 1).as("low")
            }
            WHERE {
                ARRAY_LOWER(p.$name, dimension: 1) == 5
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ARRAY_LOWER("x"."name"::TEXT, 1)::INTEGER AS "low", ARRAY_LOWER(ARRAY[1, 2, 3]::INTEGER[], 1)::INTEGER AS "low" WHERE (ARRAY_LOWER("x"."name", 1) = 5)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testArrayLength() {
        QUERY {
            SELECT {
                ARRAY_LENGTH(f.$name, dimension: 1).as("low")
                ARRAY_LENGTH(PSQLArray([1, 2, 3]), dimension: 1).as("low")
            }
            WHERE {
                ARRAY_LENGTH(f.$name, dimension: 1) == 5
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT {
                ARRAY_LENGTH(p.$name, dimension: 1).as("low")
                ARRAY_LENGTH(PSQLArray([1, 2, 3]), dimension: 1).as("low")
            }
            WHERE {
                ARRAY_LENGTH(p.$name, dimension: 1) == 5
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ARRAY_LENGTH("x"."name"::TEXT, 1)::INTEGER AS "low", ARRAY_LENGTH(ARRAY[1, 2, 3]::INTEGER[], 1)::INTEGER AS "low" WHERE (ARRAY_LENGTH("x"."name", 1) = 5)"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testArrayDims() {
        QUERY {
            SELECT {
                ARRAY_DIMS(f.$name).as("dim")
                ARRAY_DIMS(PSQLArray([1, 2, 3]))
            }
            WHERE {
                ARRAY_DIMS(f.$name) == "[5]"
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT {
                ARRAY_DIMS(p.$name).as("dim")
                ARRAY_DIMS(PSQLArray([1, 2, 3]))
            }
            WHERE {
                ARRAY_DIMS(p.$name) == "[5]"
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ARRAY_DIMS("x"."name"::TEXT)::TEXT AS "dim", ARRAY_DIMS(ARRAY[1, 2, 3]::INTEGER[])::TEXT WHERE (ARRAY_DIMS("x"."name") = '[5]')"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testArrayReplace() {
        QUERY {
            SELECT {
                ARRAY_REPLACE(f.$name, find: "hi", replace: "bye").as("rep")
                ARRAY_REPLACE(PSQLArray([1, 2, 3]), find: 1, replace: 2)
            }
            WHERE {
                ARRAY_REPLACE(f.$name, find: "hi", replace: "by") == ["hello"]
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT {
                ARRAY_REPLACE(p.$name, find: "hi", replace: "bye").as("rep")
                ARRAY_REPLACE(PSQLArray([1, 2, 3]), find: 1, replace: 2)
            }
            WHERE {
                ARRAY_REPLACE(p.$name, find: "hi", replace: "by") == ["hello"]
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ARRAY_REPLACE("x"."name"::TEXT, 'hi'::TEXT, 'bye'::TEXT)::TEXT[] AS "rep", ARRAY_REPLACE(ARRAY[1, 2, 3]::INTEGER[], 1::INTEGER, 2::INTEGER)::INTEGER[] WHERE (ARRAY_REPLACE("x"."name", 'hi', 'by') = ('hello'))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testArrayRemove() {
        QUERY {
            SELECT {
                ARRAY_REMOVE(f.$name, remove: "hi").as("rep")
                ARRAY_REMOVE(PSQLArray([1, 2, 3]), remove: 1)
            }
            WHERE {
                ARRAY_REMOVE(f.$name, remove: "hi") == ["hello"]
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT {
                ARRAY_REMOVE(p.$name, remove: "hi").as("rep")
                ARRAY_REMOVE(PSQLArray([1, 2, 3]), remove: 1)
            }
            WHERE {
                ARRAY_REMOVE(p.$name, remove: "hi") == ["hello"]
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ARRAY_REMOVE("x"."name"::TEXT, 'hi'::TEXT)::TEXT[] AS "rep", ARRAY_REMOVE(ARRAY[1, 2, 3]::INTEGER[], 1::INTEGER)::INTEGER[] WHERE (ARRAY_REMOVE("x"."name", 'hi') = ('hello'))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testArrayPrepend() {
        QUERY {
            SELECT {
                ARRAY_PREPEND(f.$name, prepend: "hi").as("pre")
                ARRAY_PREPEND(PSQLArray([1, 2, 3]), prepend: 1)
            }
            WHERE {
                ARRAY_PREPEND(f.$name, prepend: "hi") == ["hello"]
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT {
                ARRAY_PREPEND(p.$name, prepend: "hi").as("pre")
                ARRAY_PREPEND(PSQLArray([1, 2, 3]), prepend: 1)
            }
            WHERE {
                ARRAY_PREPEND(p.$name, prepend: "hi") == ["hello"]
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ARRAY_PREPEND('hi'::TEXT, "x"."name"::TEXT)::TEXT[] AS "pre", ARRAY_PREPEND(1::INTEGER, ARRAY[1, 2, 3]::INTEGER[])::INTEGER[] WHERE (ARRAY_PREPEND('hi', "x"."name") = ('hello'))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testArrayConcatenate() {
        QUERY {
            SELECT {
                ARRAY_CAT(f.$name, f.$name).as("app")
                ARRAY_CAT(PSQLArray([1, 2, 3]), PSQLArray([1, 2, 3]))
            }
            WHERE {
                ARRAY_CAT(f.$name, PSQLArray(["hi"])) == ["hello"]
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT {
                ARRAY_CAT(p.$name, p.$name).as("app")
                ARRAY_CAT(PSQLArray([1, 2, 3]), PSQLArray([1, 2, 3]))
            }
            WHERE {
                ARRAY_CAT(f.$name, PSQLArray(["hi"])) == ["hello"]
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ARRAY_CAT("x"."name"::TEXT, "x"."name"::TEXT)::TEXT[] AS "app", ARRAY_CAT(ARRAY[1, 2, 3]::INTEGER[], ARRAY[1, 2, 3]::INTEGER[])::INTEGER[] WHERE (ARRAY_CAT("x"."name", ARRAY['hi']) = ('hello'))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testArrayAppend() {
        QUERY {
            SELECT {
                ARRAY_APPEND(f.$name, append: "hi").as("app")
                ARRAY_APPEND(PSQLArray([1, 2, 3]), append: 1)
            }
            WHERE {
                ARRAY_APPEND(f.$name, append: "hi") == ["hello"]
            }
        }
        .serialize(to: &fluentSerializer)

        QUERY {
            SELECT {
                ARRAY_APPEND(p.$name, append: "hi").as("app")
                ARRAY_APPEND(PSQLArray([1, 2, 3]), append: 1)
            }
            WHERE {
                ARRAY_APPEND(p.$name, append: "hi") == ["hello"]
            }
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT ARRAY_APPEND("x"."name"::TEXT, 'hi'::TEXT)::TEXT[] AS "app", ARRAY_APPEND(ARRAY[1, 2, 3]::INTEGER[], 1::INTEGER)::INTEGER[] WHERE (ARRAY_APPEND("x"."name", 'hi') = ('hello'))"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testConcateWithCoalesce() {
        SELECT {
            CONCAT(COALESCE(f.$name, "hi"), " there")
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            CONCAT(COALESCE(p.$name, "hi"), " there")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT CONCAT(COALESCE("x"."name", 'hi'), ' there')::TEXT"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testDateTrunc() {
        SELECT {
            DATE_TRUNC("hour", p.$birthday).as("datehour")
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            DATE_TRUNC("hour", p.$birthday).as("datehour")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT DATE_TRUNC('hour', "x"."birthday"::TIMESTAMP) AS "datehour""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }

    func testDatePart() {
        SELECT {
            DATE_PART("hour", p.$birthday).as("hour")
        }
        .serialize(to: &fluentSerializer)

        SELECT {
            DATE_PART("hour", p.$birthday).as("hour")
        }
        .serialize(to: &psqlkitSerializer)

        let compare = #"SELECT DATE_PART('hour', "x"."birthday"::TIMESTAMP) AS "hour""#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
}
