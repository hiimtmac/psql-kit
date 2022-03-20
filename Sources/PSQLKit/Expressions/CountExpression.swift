// CountExpression.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct CountExpression<Content>: AggregateExpression {
    let content: Content

    public init(_ content: Content) {
        self.content = content
    }
}

extension CountExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: SQLExpression {
        _Select(content: self.content)
    }

    private struct _Select: SQLExpression {
        let content: Content

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("COUNT")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension CountExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: SQLExpression {
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
}
