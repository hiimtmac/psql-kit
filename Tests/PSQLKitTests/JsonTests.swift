// JsonTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit
import Testing
import PSQLKit

@Suite
struct JsonTests {
    let p = PSQLModel.as("x")

    @Test
    func testGroup() {
        var serializer = SQLSerializer.test

        SELECT {
            JSONB_EXTRACT_PATH_TEXT(p.$pet, \.$name)
            JSONB_EXTRACT_PATH_TEXT(p.$pet, \.$info, \.$name)
        }
        .serialize(to: &serializer)

        let compare = #"SELECT JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'name')::TEXT, JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'info', 'name')::TEXT"#
        #expect(serializer.sql == compare)
    }
    
    @Test
    func testAccessors() {
        var serializer = SQLSerializer.test

        SELECT {
            p.$pet --> "hello" --> "there" -->> "cool"
            p.$pet --> "hello" --> "there"
            p.$pet --> "hello" -->> "cool"
            p.$pet -->> "cool"
            p.$pet --> "hello"
            p.$pet --> p.$name --> "hello"
            (p.$pet -->> "cool").as("cool")
            (p.$pet --> "hello").as("hello")
        }
        .serialize(to: &serializer)

        let compare = [
            #"SELECT ("x"."pet"->'hello'->'there'->>'cool')::TEXT"#,
            #""x"."pet"->'hello'->'there'"#,
            #"("x"."pet"->'hello'->>'cool')::TEXT"#,
            #"("x"."pet"->>'cool')::TEXT"#,
            #""x"."pet"->'hello'"#,
            #""x"."pet"->"x"."name"->'hello'"#,
            #"("x"."pet"->>'cool')::TEXT AS "cool""#,
            #""x"."pet"->'hello' AS "hello""#
        ].joined(separator: ", ")
        #expect(serializer.sql == compare)
    }

    @Test
    func testExtractPathText() {
        var serializer = SQLSerializer.test

        SELECT {
            JSONB_EXTRACT_PATH_TEXT(p.$pet, "hello").as("cool")
            JSONB_EXTRACT_PATH_TEXT(p.$pet, "hello", "cool")
        }
        .serialize(to: &serializer)

        let compare = #"SELECT JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'hello')::TEXT AS "cool", JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'hello', 'cool')::TEXT"#
        #expect(serializer.sql == compare)
    }
    
    @Test
    func testExtractPath() {
        var serializer = SQLSerializer.test

        SELECT {
            JSONB_EXTRACT_PATH(p.$pet, "hello", as: String.self).as("cool")
            JSONB_EXTRACT_PATH(p.$pet, "hello", "cool", as: String.self)
        }
        .serialize(to: &serializer)

        let compare = #"SELECT JSONB_EXTRACT_PATH("x"."pet"::JSONB, 'hello')::TEXT AS "cool", JSONB_EXTRACT_PATH("x"."pet"::JSONB, 'hello', 'cool')::TEXT"#
        #expect(serializer.sql == compare)
    }

    @Test
    func testNestedExtract() {
        var serializer = SQLSerializer.test

        SELECT {
            COALESCE(
                JSONB_EXTRACT_PATH_TEXT(p.$pet, \.$name),
                JSONB_EXTRACT_PATH_TEXT(p.$pet, \.$type)
            )
        }
        .serialize(to: &serializer)

        let compare = #"SELECT COALESCE(JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'name'), JSONB_EXTRACT_PATH_TEXT("x"."pet"::JSONB, 'type'))::TEXT"#
        #expect(serializer.sql == compare)
    }
    
    @Test
    func testObjectAgg() {
        var serializer = SQLSerializer.test

        SELECT {
            JSONB_OBJECT_AGG(p.$name, p.$age)
            JSONB_OBJECT_AGG("name".as(columnOf: String.self), 1, as: [String: Int].self)
            JSONB_OBJECT_AGG("name".as(columnOf: String.self), 1)
        }
        .serialize(to: &serializer)

        let compare = #"SELECT JSONB_OBJECT_AGG("x"."name"::TEXT, "x"."age"::INTEGER)::JSONB, JSONB_OBJECT_AGG("name"::TEXT, 1::INTEGER)::JSONB, JSONB_OBJECT_AGG("name"::TEXT, 1::INTEGER)::JSONB"#
        #expect(serializer.sql == compare)
    }
    
    @Test
    func testCreateObject() {
        var serializer = SQLSerializer.test

        SELECT {
            JSONB_BUILD_OBJECT((p.$name, p.$age), (p.$title, p.$age), as: [String: Int].self)
            JSONB_BUILD_OBJECT(("id", p.$age), ("name", 1))
        }
        .serialize(to: &serializer)

        let compare = #"SELECT JSONB_BUILD_OBJECT("x"."name", "x"."age", "x"."title", "x"."age")::JSONB, JSONB_BUILD_OBJECT('id', "x"."age", 'name', 1)::JSONB"#
        #expect(serializer.sql == compare)
    }
}
