// ArrayLowerExpression.swift
// Copyright © 2022 hiimtmac

import Foundation
import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct ArrayLowerExpression<Content>: AggregateExpression where
    Content: PSQLArrayRepresentable
{
    let content: Content
    let dimension: Int

    public init(_ content: Content, dimension: Int) {
        self.content = content
        self.dimension = dimension
    }
}

extension ArrayLowerExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content, dimension: self.dimension)
    }

    private struct _Select: SQLExpression {
        let content: Content
        let dimension: Int

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_LOWER")
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

extension ArrayLowerExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content, dimension: self.dimension)
    }

    private struct _Compare: SQLExpression {
        let content: Content
        let dimension: Int

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_LOWER")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.dimension.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayLowerExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Int
}

extension ArrayLowerExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayLowerExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
