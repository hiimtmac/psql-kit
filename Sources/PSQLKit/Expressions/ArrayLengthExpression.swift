// ArrayLengthExpression.swift
// Copyright © 2022 hiimtmac

import Foundation
import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct ArrayLengthExpression<Content>: AggregateExpression where
    Content: PSQLArrayRepresentable
{
    let content: Content
    let dimension: Int

    public init(_ content: Content, dimension: Int) {
        self.content = content
        self.dimension = dimension
    }
}

extension ArrayLengthExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content, dimension: self.dimension)
    }

    private struct _Select: SQLExpression {
        let content: Content
        let dimension: Int

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_LENGTH")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.dimension.serialize(to: &serializer)
            serializer.write(")")
            PostgresDataType.int4.serialize(to: &serializer)
        }
    }
}

extension ArrayLengthExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content, dimension: self.dimension)
    }

    private struct _Compare: SQLExpression {
        let content: Content
        let dimension: Int

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_LENGTH")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.dimension.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayLengthExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Int
}

extension ArrayLengthExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayLengthExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
