// JsonExtractPathText.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public protocol JsonbExtractable: BaseSQLExpression {}

public struct JsonbExtractPathTextExpression<Content>: Sendable {
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

    struct _Base: SQLExpression {
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

    struct _Select: SQLExpression {
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

// MARK: PSQLKit

extension JsonbExtractPathTextExpression {
    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T.QueryContainer, ColumnAccessor<Content>>
    ) where T: Table {
        self.content = group.baseSqlExpression
        self.pathElements = [T.queryContainer[keyPath: keyPath].column]
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<Content>>
    ) where T: Table, U: Table {
        self.content = group.baseSqlExpression
        self.pathElements = [
            T.queryContainer[keyPath: first].column,
            U.queryContainer[keyPath: second].column
        ]
    }
}
