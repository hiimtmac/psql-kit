// TableMacroTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SwiftSyntaxMacrosTestSupport
import XCTest

final class TableMacroTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            @Table("test_table", schema: "test_schema")
            public struct Test {
                @CTECol("test_column")
                public var testColumn: Int

                var another: String

                @CTEIgnore
                var testIgnore: Int

                var more: String { "" }
            }
            """,
            expandedSource: """

                public struct Test {
                    public var testColumn: Int

                    var another: String
                    var testIgnore: Int

                    var more: String { "" }

                    public struct QueryContainer {
                        @ColumnAccessor<Int>("test_column") public var testColumn: Never
                        @ColumnAccessor<String>("another") var another: Never
                    }
                }

                extension Test: Table {
                    public static let tableName: String = "test_table"
                    public static let schemaName: String? = "test_schema"
                    public static let queryContainer = QueryContainer()
                }
                """,
            macros: testMacros
        )
    }

//    func testMacro() {
//        assertMacroExpansion(
//            """
//            @Column(name: "test_column")
//            public var testColumn: Int
//            """,
//            expandedSource: """
//
//            public var testColumn: Int
//            @ColumnExpression(name: "test_column") public static var testColumn
//            """,
//            macros: testMacros
//        )
//    }
}
