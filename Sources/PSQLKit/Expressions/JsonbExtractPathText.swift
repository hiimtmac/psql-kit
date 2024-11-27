// JsonbExtractPathText.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct JsonbExtractPathTextExpression: Sendable {
    let content: any SQLExpression
    let elements: SQLList

    public init<T, each U>(_ content: T, _ paths: repeat each U) where
        T: SelectSQLExpression,
        repeat each U: BaseSQLExpression
    {
        self.content = content.selectSqlExpression
        self.elements = SQLList(jsonSQLExpressions: repeat each paths)
    }
}

extension JsonbExtractPathTextExpression: Coalescable {}

extension JsonbExtractPathTextExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        _Base(content: self.content, elements: self.elements)
    }

    struct _Base: SQLExpression {
        let content: any SQLExpression
        let elements: SQLList

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("JSONB_EXTRACT_PATH_TEXT")
            serializer.write("(")
            self.content.serialize(to: &serializer)
            serializer.write(",")
            serializer.writeSpace()
            self.elements.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension JsonbExtractPathTextExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Select(
            content: self.content,
            elements: self.elements
        )
    }

    struct _Select: SQLExpression {
        let content: any SQLExpression
        let elements: SQLList

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("JSONB_EXTRACT_PATH_TEXT")
            serializer.write("(")
            self.content.serialize(to: &serializer)
            serializer.write(",")
            serializer.writeSpace()
            self.elements.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeCast(.text)
        }
    }
}

extension JsonbExtractPathTextExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonbExtractPathTextExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonbExtractPathTextExpression: TypeEquatable {
    public typealias CompareType = String
}

extension JsonbExtractPathTextExpression {
    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T.QueryContainer, ColumnAccessor<U>>
    ) where T: Table {
        let accessor = T.queryContainer[keyPath: keyPath]
        
        self.init(
            group,
            accessor.column
        )
    }

    public init<T, U, V>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<V>>
    ) where T: Table, U: Table {
        let accessor1 = T.queryContainer[keyPath: first]
        let accessor2 = U.queryContainer[keyPath: second]
        
        self.init(
            group,
            accessor1.column, accessor2.column
        )
    }
    
    public init<T, U, V, W>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<V>>,
        _ third: KeyPath<V.QueryContainer, ColumnAccessor<W>>
    ) where T: Table, U: Table, V: Table {
        let accessor1 = T.queryContainer[keyPath: first]
        let accessor2 = U.queryContainer[keyPath: second]
        let accessor3 = V.queryContainer[keyPath: third]
        
        self.init(
            group,
            accessor1.column, accessor2.column, accessor3.column
        )
    }
}
