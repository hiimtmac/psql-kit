// ArrayAppendExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct ArrayAppendExpression<Content, T>: AggregateExpression where
    Content: PSQLArrayRepresentable & TypeEquatable,
    T: TypeEquatable,
    Content.CompareType == T.CompareType
{
    let content: Content
    let append: T

    public init(_ content: Content, append: T) {
        self.content = content
        self.append = append
    }
}

extension ArrayAppendExpression: SelectSQLExpression where
    Content: SelectSQLExpression,
    T: PSQLExpression & SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content, append: self.append)
    }

    private struct _Select: SQLExpression {
        let content: Content
        let append: T

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_APPEND")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.append.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            PostgresDataType.array(T.postgresDataType).serialize(to: &serializer)
        }
    }
}

extension ArrayAppendExpression: CompareSQLExpression where
    Content: CompareSQLExpression,
    T: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content, append: self.append)
    }

    private struct _Compare: SQLExpression {
        let content: Content
        let append: T

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_APPEND")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.append.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayAppendExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = [Content.CompareType]
}

extension ArrayAppendExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayAppendExpression<Content, T>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
