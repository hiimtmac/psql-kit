// ConcatenateExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

public protocol Concatenatable: BaseSQLExpression {}

// MARK: ConcatenateExpression

public struct ConcatenateExpression: Sendable {
    let elements: SQLList

    public init<each T>(_ content: repeat each T) where repeat each T: Concatenatable & Sendable {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            collector.append(expression.baseSqlExpression)
        }
        self.elements = SQLList(collector, separator: SQLRaw(", "))
    }
}

extension ConcatenateExpression: TypeEquatable {
    public typealias CompareType = String
}

extension ConcatenateExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        _Base(elements: self.elements)
    }

    struct _Base: SQLExpression {
        let elements: SQLList

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            self.elements.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Select(elements: self.elements)
    }

    struct _Select: SQLExpression {
        let elements: SQLList

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            self.elements.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeCast(.text)
        }
    }
}

extension ConcatenateExpression: GroupBySQLExpression {
    public var groupBySqlExpression: some SQLExpression {
        baseSqlExpression
    }
}

extension ConcatenateExpression: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression {
        baseSqlExpression
    }
}

extension ConcatenateExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ConcatenateExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
