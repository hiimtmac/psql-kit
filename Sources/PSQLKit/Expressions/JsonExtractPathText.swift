// JsonExtractPathText.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer
import struct SQLKit.SQLList
import class FluentKit.FieldProperty
import class FluentKit.OptionalFieldProperty
import class FluentKit.IDProperty
import class FluentKit.TimestampProperty
import class FluentKit.GroupProperty

public protocol JsonbExtractable: BaseSQLExpression {}

public struct JsonbExtractPathTextExpression<Content> {
    let content: any SQLExpression
    let pathElements: [String]

    public init<T>(_ content: T, _ paths: String..., as _: Content.Type) where
        T: JsonbExtractable
    {
        self.content = content.baseSqlExpression
        self.pathElements = paths
    }
}

extension JsonbExtractPathTextExpression: Coalescable where Content: TypeEquatable {}

extension JsonbExtractPathTextExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        _Base(content: self.content, pathElements: self.pathElements)
    }

    private struct _Base: SQLExpression {
        let content: any SQLExpression
        let pathElements: [String]

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("JSONB_EXTRACT_PATH_TEXT")
            serializer.write("(")
            self.content.serialize(to: &serializer)
            serializer.write(",")
            serializer.writeSpace()
            SQLList(self.pathElements).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension JsonbExtractPathTextExpression: SelectSQLExpression where
    Content: PSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(
            content: self.content,
            pathElements: self.pathElements,
            dataType: Content.postgresDataType
        )
    }

    private struct _Select: SQLExpression {
        let content: any SQLExpression
        let pathElements: [String]
        let dataType: any SQLExpression

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("JSONB_EXTRACT_PATH_TEXT")
            serializer.write("(")
            self.content.serialize(to: &serializer)
            serializer.write(",")
            serializer.writeSpace()
            SQLList(self.pathElements).serialize(to: &serializer)
            serializer.write(")")
            self.dataType.serialize(to: &serializer)
        }
    }
}

extension JsonbExtractPathTextExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonbExtractPathTextExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonbExtractPathTextExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Content.CompareType
}

// MARK: Fluent

extension JsonbExtractPathTextExpression {
    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, FieldProperty<T, Content>>
    ) {
        self.content = group.baseSqlExpression
        self.pathElements = [T()[keyPath: keyPath].key.description]
    }

    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, OptionalFieldProperty<T, Content>>
    ) {
        self.content = group.baseSqlExpression
        self.pathElements = [T()[keyPath: keyPath].key.description]
    }

    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, TimestampProperty<T, Content>>
    ) {
        self.content = group.baseSqlExpression
        self.pathElements = [T()[keyPath: keyPath].$timestamp.key.description]
    }

    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, IDProperty<T, Content>>
    ) {
        self.content = group.baseSqlExpression
        self.pathElements = [T()[keyPath: keyPath].key.description]
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, FieldProperty<U, Content>>
    ) {
        self.content = group.baseSqlExpression
        self.pathElements = [T()[keyPath: first].key.description, U()[keyPath: second].key.description]
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, OptionalFieldProperty<U, Content>>
    ) {
        self.content = group.baseSqlExpression
        self.pathElements = [T()[keyPath: first].key.description, U()[keyPath: second].key.description]
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, TimestampProperty<U, Content>>
    ) {
        self.content = group.baseSqlExpression
        self.pathElements = [T()[keyPath: first].key.description, U()[keyPath: second].$timestamp.key.description]
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, IDProperty<U, Content>>
    ) {
        self.content = group.baseSqlExpression
        self.pathElements = [T()[keyPath: first].key.description, U()[keyPath: second].key.description]
    }
}

// MARK: PSQLKit

extension JsonbExtractPathTextExpression {
    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, ColumnProperty<T, Content>>
    ) where T: TableObject {
        self.content = group.baseSqlExpression
        self.pathElements = [T()[keyPath: keyPath].key.description]
    }

    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, OptionalColumnProperty<T, Content>>
    ) where T: TableObject {
        self.content = group.baseSqlExpression
        self.pathElements = [T()[keyPath: keyPath].key.description]
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, NestedObjectProperty<T, U>>,
        _ second: KeyPath<U, ColumnProperty<U, Content>>
    ) where T: TableObject, U: TableObject {
        self.content = group.baseSqlExpression
        self.pathElements = [T()[keyPath: first].key.description, U()[keyPath: second].key.description]
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, NestedObjectProperty<T, U>>,
        _ second: KeyPath<U, OptionalColumnProperty<U, Content>>
    ) where T: TableObject, U: TableObject {
        self.content = group.baseSqlExpression
        self.pathElements = [T()[keyPath: first].key.description, U()[keyPath: second].key.description]
    }
}
