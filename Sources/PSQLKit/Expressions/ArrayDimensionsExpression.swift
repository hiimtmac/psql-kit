// ArrayDimensionsExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

public struct ArrayDimensionsExpression<Content>: AggregateExpression, Sendable where
    Content: PSQLArrayRepresentable & Sendable
{
    let content: Content

    public init(_ content: Content) {
        self.content = content
    }
}

extension ArrayDimensionsExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content)
    }

    struct _Select: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_DIMS")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeCast(.text)
        }
    }
}

extension ArrayDimensionsExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content)
    }

    struct _Compare: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_DIMS")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayDimensionsExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = String
}

extension ArrayDimensionsExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayDimensionsExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
