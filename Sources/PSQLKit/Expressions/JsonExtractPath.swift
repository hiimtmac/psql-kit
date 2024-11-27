// JsonExtractPath.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

public struct JsonExtractPathExpression<Content>: Sendable where Content: PSQLExpression & Decodable {
    let content: any SQLExpression
    let elements: SQLList

    public init<T, each U>(_ content: T, _ paths: repeat each U, as _: Content.Type) where
        T: SelectSQLExpression,
        repeat each U: BaseSQLExpression
    {
        self.content = content.selectSqlExpression
        self.elements = SQLList(jsonSQLExpressions: repeat each paths)
    }
}

extension JsonExtractPathExpression: Coalescable {}

extension JsonExtractPathExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        _Base(
            content: self.content,
            elements: self.elements
        )
    }

    struct _Base: SQLExpression {
        let content: any SQLExpression
        let elements: SQLList

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("JSON_EXTRACT_PATH")
            serializer.write("(")
            self.content.serialize(to: &serializer)
            serializer.write(",")
            serializer.writeSpace()
            self.elements.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension JsonExtractPathExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Select(
            content: self.content,
            elements: self.elements,
            dataType: Content.postgresDataType
        )
    }

    struct _Select: SQLExpression {
        let content: any SQLExpression
        let elements: SQLList
        let dataType: PostgresDataType

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("JSON_EXTRACT_PATH")
            serializer.write("(")
            self.content.serialize(to: &serializer)
            serializer.write(",")
            serializer.writeSpace()
            self.elements.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeCast(dataType)
        }
    }
}

extension JsonExtractPathExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<JsonExtractPathExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JsonExtractPathExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Content.CompareType
}

extension JsonExtractPathExpression {
    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T.QueryContainer, ColumnAccessor<Content>>
    ) where T: Table & JSONCol {
        let accessor = T.queryContainer[keyPath: keyPath]
        
        self.init(
            group,
            accessor.column,
            as: Content.self
        )
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<Content>>
    ) where T: Table & JSONCol, U: Table & JSONCol {
        let accessor1 = T.queryContainer[keyPath: first]
        let accessor2 = U.queryContainer[keyPath: second]
        
        self.init(
            group,
            accessor1.column, accessor2.column,
            as: Content.self
        )
    }
    
    public init<T, U, V>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T.QueryContainer, ColumnAccessor<U>>,
        _ second: KeyPath<U.QueryContainer, ColumnAccessor<V>>,
        _ third: KeyPath<V.QueryContainer, ColumnAccessor<Content>>
    ) where T: Table & JSONCol, U: Table & JSONCol, V: Table & JSONCol {
        let accessor1 = T.queryContainer[keyPath: first]
        let accessor2 = U.queryContainer[keyPath: second]
        let accessor3 = V.queryContainer[keyPath: third]
        
        self.init(
            group,
            accessor1.column, accessor2.column, accessor3.column,
            as: Content.self
        )
    }
}
