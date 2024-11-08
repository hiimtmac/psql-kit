// Table.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

@dynamicMemberLookup
public protocol CTE: FromSQLExpression {
    associatedtype QueryContainer
    static var queryContainer: QueryContainer { get }
    static var tableName: String { get }
    static var schemaName: String? { get }
}

extension CTE {
    public static subscript<T>(
        dynamicMember keyPath: KeyPath<QueryContainer, ColumnAccessor<T>>
    ) -> ColumnExpression<T> {
        let field = Self.queryContainer[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            schemaName: Self.schemaName,
            tableName: Self.tableName,
            columnName: field.column
        )
    }

    public static func `as`(_ alias: String) -> CTEAlias<Self> {
        .init(alias: alias)
    }

    public var fromSqlExpression: some SQLExpression {
        _TableFrom(schemaName: Self.schemaName, tableName: Self.tableName)
    }

    public static var table: CTETable<Self> {
        CTETable()
    }
}

public struct CTETable<T>: FromSQLExpression where T: CTE {
    public var fromSqlExpression: some SQLExpression {
        _TableFrom(schemaName: T.schemaName, tableName: T.tableName)
    }

    public static postfix func .* (cte: Self) -> AllCTESelection<T> {
        .init(cte: cte)
    }

    public func `as`(_ alias: String) -> CTEAlias<T> {
        .init(alias: alias)
    }
}

package struct _TableFrom: SQLExpression, FromSQLExpression {
    let schemaName: String?
    let tableName: String

    package init(schemaName: String?, tableName: String) {
        self.schemaName = schemaName
        self.tableName = tableName
    }

    package var fromSqlExpression: some SQLExpression {
        self
    }

    package func serialize(to serializer: inout SQLSerializer) {
        if let path = schemaName {
            serializer.writeQuote()
            serializer.write(path)
            serializer.writeQuote()
            serializer.writePeriod()
        }

        serializer.writeQuote()
        serializer.write(self.tableName)
        serializer.writeQuote()
    }
}
