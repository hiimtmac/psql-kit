// ArrayUpperExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

public struct ArrayUpperExpression<Content>: AggregateExpression, Sendable where
    Content: PSQLArrayRepresentable & Sendable
{
    let content: Content
    let dimension: Int

    public init(_ content: Content, dimension: Int) {
        self.content = content
        self.dimension = dimension
    }
}

extension ArrayUpperExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content, dimension: self.dimension)
    }

    struct _Select: SQLExpression {
        let content: Content
        let dimension: Int

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_UPPER")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.dimension.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeCast(.int4)
        }
    }
}

extension ArrayUpperExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content, dimension: self.dimension)
    }

    struct _Compare: SQLExpression {
        let content: Content
        let dimension: Int

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_UPPER")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.dimension.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayUpperExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Int
}

extension ArrayUpperExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayUpperExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
