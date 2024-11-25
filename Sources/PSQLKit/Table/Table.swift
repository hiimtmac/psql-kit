// Table.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

@dynamicMemberLookup
public protocol Table: FromSQLExpression {
    associatedtype QueryContainer
    static var queryContainer: QueryContainer { get }
    static var tableName: String { get }
    static var schemaName: String? { get }
}

extension Table {
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

    public static func `as`(_ alias: String) -> TableAlias<Self> {
        .init(alias: alias)
    }

    public var fromSqlExpression: some SQLExpression {
        _From(schemaName: Self.schemaName, tableName: Self.tableName)
    }

    public static var table: TableInstance<Self> {
        TableInstance()
    }
}

public struct TableInstance<T>: FromSQLExpression where T: Table {
    public var fromSqlExpression: some SQLExpression {
        _From(schemaName: T.schemaName, tableName: T.tableName)
    }

    public static postfix func .* (cte: Self) -> AllCTESelection<T> {
        .init(cte: cte)
    }

    public func `as`(_ alias: String) -> TableAlias<T> {
        .init(alias: alias)
    }
}

fileprivate struct _From: SQLExpression, FromSQLExpression {
    let schemaName: String?
    let tableName: String

    init(schemaName: String?, tableName: String) {
        self.schemaName = schemaName
        self.tableName = tableName
    }

    var fromSqlExpression: some SQLExpression {
        self
    }

    func serialize(to serializer: inout SQLSerializer) {
        if let path = schemaName {
            serializer.writeIdentifier(path)
            serializer.writePeriod()
        }

        serializer.writeIdentifier(self.tableName)
    }
}
