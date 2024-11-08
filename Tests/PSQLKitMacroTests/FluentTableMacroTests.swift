// FluentTableMacroTests.swift
// Copyright (c) 2024 hiimtmac inc.

import SwiftSyntaxMacrosTestSupport
import XCTest

final class FluentTableMacroTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            @FluentCTE("test_table", schema: "test_schema")
            public final class Test {
                @ID
                public var id: UUID?

                @Field(key: "another")
                var another: String

                @OptionalField(key: "next")
                var next: Int?

                @Group(key: "group")
                var group: Group

                @Parent(key: "parent")
                var parent: Parent

                @OptionalParent(key: "optional_parent")
                var optionalParent: OptionalParent?

                var testIgnore: Int

                var more: String { "" }
            }
            """,
            expandedSource: """

                public final class Test {
                    @ID
                    public var id: UUID?

                    @Field(key: "another")
                    var another: String

                    @OptionalField(key: "next")
                    var next: Int?

                    @Group(key: "group")
                    var group: Group

                    @Parent(key: "parent")
                    var parent: Parent

                    @OptionalParent(key: "optional_parent")
                    var optionalParent: OptionalParent?

                    var testIgnore: Int

                    var more: String { "" }
                
                    public struct QueryContainer {
                        @ColumnAccessor<UUID>("id") public var id: Never
                        @ColumnAccessor<String>("another") var another: Never
                        @ColumnAccessor<Int>("next") var next: Never
                        @ColumnAccessor<Group>("group") var group: Never
                        @ColumnAccessor<Parent.IDValue>("parent") var parent: Never
                        @ColumnAccessor<OptionalParent.IDValue>("optional_parent") var optionalParent: Never
                    }
                }

                extension Test: Table {
                    public static let schema: String = "test_table"
                    public static let space: String? = "test_schema"
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
