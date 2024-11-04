// ConcatenateExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLList
import struct SQLKit.SQLSerializer

public protocol Concatenatable: BaseSQLExpression {}

// MARK: ConcatenateExpression

public struct ConcatenateExpression: Sendable {
    let list: SQLList
    
    public init<each T>(_ content: repeat each T) where repeat each T: Concatenatable {
        self.list = SQLList(concatSQLExpressions: repeat each content)
    }
}

extension ConcatenateExpression: TypeEquatable {
    public typealias CompareType = String
}

extension ConcatenateExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        _Base(list: list)
    }

    private struct _Base: SQLExpression {
        let list: SQLList

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            list.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ConcatenateExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Select(list: list)
    }

    private struct _Select: SQLExpression {
        let list: SQLList

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CONCAT")
            serializer.write("(")
            list.serialize(to: &serializer)
            serializer.write(")")
            PostgresDataType.text.serialize(to: &serializer)
        }
    }
}

extension ConcatenateExpression: GroupBySQLExpression {
    public var groupBySqlExpression: some SQLExpression {
        _Base(list: list)
    }
}

extension ConcatenateExpression: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression {
        _Base(list: list)
    }
}

extension ConcatenateExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ConcatenateExpression> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
