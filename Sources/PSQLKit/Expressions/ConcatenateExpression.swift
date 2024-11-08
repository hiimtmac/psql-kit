// ConcatenateExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

public protocol Concatenatable: BaseSQLExpression {}

// MARK: ConcatenateExpression

public struct ConcatenateExpression<each T>: Sendable where repeat each T: Concatenatable & Sendable {
    let content: (repeat each T)

    public init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
}

extension ConcatenateExpression: TypeEquatable {
    public typealias CompareType = String
}

extension ConcatenateExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        _Base(content: repeat each content)
    }

    struct _Base: SQLExpression {
        let content: (repeat each T)

        init(content: repeat each T) {
            self.content = (repeat each content)
        }

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList(concatSQLExpressions: repeat each content).serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Select(content: repeat each content)
    }

    struct _Select: SQLExpression {
        let content: (repeat each T)

        init(content: repeat each T) {
            self.content = (repeat each content)
        }

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            SQLList(concatSQLExpressions: repeat each content).serialize(to: &serializer)
            serializer.write(")")
            PostgresDataType.text.serialize(to: &serializer)
        }
    }
}

extension ConcatenateExpression: GroupBySQLExpression {
    public var groupBySqlExpression: some SQLExpression {
        _Base(content: repeat each content)
    }
}

extension ConcatenateExpression: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression {
        _Base(content: repeat each content)
    }
}

extension ConcatenateExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ConcatenateExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
