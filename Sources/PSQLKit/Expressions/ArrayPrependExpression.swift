// ArrayPrependExpression.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

public struct ArrayPrependExpression<Content, T>: AggregateExpression where
    Content: PSQLArrayRepresentable & TypeEquatable,
    T: TypeEquatable,
    Content.CompareType == T.CompareType
{
    let content: Content
    let prepend: T

    public init(_ content: Content, prepend: T) {
        self.content = content
        self.prepend = prepend
    }
}

extension ArrayPrependExpression: SelectSQLExpression where
    Content: SelectSQLExpression,
    T: PSQLExpression & SelectSQLExpression
{
    public var selectSqlExpression: SQLExpression {
        _Select(content: self.content, prepend: self.prepend)
    }

    private struct _Select: SQLExpression {
        let content: Content
        let prepend: T

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_PREPEND")
            serializer.write("(")
            self.prepend.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.write("::")
            PostgresColumnType.array(T.postgresColumnType).serialize(to: &serializer)
        }
    }
}

extension ArrayPrependExpression: CompareSQLExpression where
    Content: CompareSQLExpression,
    T: CompareSQLExpression
{
    public var compareSqlExpression: SQLExpression {
        _Compare(content: self.content, prepend: self.prepend)
    }

    private struct _Compare: SQLExpression {
        let content: Content
        let prepend: T

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_PREPEND")
            serializer.write("(")
            self.prepend.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayPrependExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = [Content.CompareType]
}

extension ArrayPrependExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayPrependExpression<Content, T>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
