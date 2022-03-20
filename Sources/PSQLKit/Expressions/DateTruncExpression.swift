// DateTruncExpression.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

public struct DateTruncExpression<Content>: AggregateExpression where
    Content: PSQLArrayRepresentable & TypeEquatable
{
    let precision: String
    let content: Content

    public init(_ precision: String, _ content: Content) {
        self.precision = precision
        self.content = content
    }
}

extension DateTruncExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: SQLExpression {
        _Select(precision: self.precision, content: self.content)
    }

    private struct _Select: SQLExpression {
        let precision: String
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("DATE_TRUNC")
            serializer.write("(")
            self.precision.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension DateTruncExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<DateTruncExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
