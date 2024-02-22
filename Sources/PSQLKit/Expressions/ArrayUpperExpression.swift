// ArrayUpperExpression.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

public struct ArrayUpperExpression<Content>: AggregateExpression where
    Content: PSQLArrayRepresentable
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
    public var selectSqlExpression: SQLExpression {
        _Select(content: self.content, dimension: self.dimension)
    }

    private struct _Select: SQLExpression {
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
            PostgresDataType.int4.serialize(to: &serializer)
        }
    }
}

extension ArrayUpperExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: SQLExpression {
        _Compare(content: self.content, dimension: self.dimension)
    }

    private struct _Compare: SQLExpression {
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
