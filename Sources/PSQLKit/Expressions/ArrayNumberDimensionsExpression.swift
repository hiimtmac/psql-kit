// ArrayNumberDimensionsExpression.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

public struct ArrayNumberDimensionsExpression<Content>: AggregateExpression where
    Content: PSQLArrayRepresentable
{
    let content: Content

    public init(_ content: Content) {
        self.content = content
    }
}

extension ArrayNumberDimensionsExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: SQLExpression {
        _Select(content: self.content)
    }

    private struct _Select: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_NDIMS")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.write("::")
            PostgresColumnType.integer.serialize(to: &serializer)
        }
    }
}

extension ArrayNumberDimensionsExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: SQLExpression {
        _Compare(content: self.content)
    }

    private struct _Compare: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_NDIMS")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayNumberDimensionsExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Int
}

extension ArrayNumberDimensionsExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayNumberDimensionsExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
