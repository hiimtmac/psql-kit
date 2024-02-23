// MaxExpression.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct MaxExpression<Content>: AggregateExpression {
    let content: Content

    public init(_ content: Content) {
        self.content = content
    }
}

extension MaxExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content)
    }

    private struct _Select: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("MAX")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension MaxExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content)
    }

    private struct _Compare: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("MAX")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension MaxExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Content.CompareType
}

extension MaxExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<MaxExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
