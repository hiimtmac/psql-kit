// CountExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct CountExpression<Content>: AggregateExpression {
    let content: Content
    let isDistinct: Bool

    init(_ content: Content, distinct: Bool) {
        self.content = content
        self.isDistinct = distinct
    }

    public init(_ content: Content) {
        self.content = content
        self.isDistinct = false
    }
}

extension CountExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content, distinct: self.isDistinct)
    }

    private struct _Select: SQLExpression {
        let content: Content
        let distinct: Bool

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("COUNT")
            serializer.write("(")
            if self.distinct {
                serializer.write("DISTINCT")
                serializer.writeSpace()
            }
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension CountExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content)
    }

    private struct _Compare: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("COUNT")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension CountExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Content.CompareType
}

extension CountExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<CountExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }

    public func distinct(_ isDistinct: Bool = true) -> Self {
        .init(self.content, distinct: isDistinct)
    }
}
