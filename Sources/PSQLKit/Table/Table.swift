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
        _From(schemaName: Self.schemaName, tableName: Self.tableName)
    }
    
    public static postfix func .* (cte: Self) -> AllCTESelection<Self> {
        .init(cte: cte)
    }
}

@dynamicMemberLookup
public protocol Table: FromSQLExpression, Sendable {
    init()
    /// fluent `table`
    static var schema: String { get }
    /// psql `schema`
    static var path: String? { get }
}

extension Table {
    public typealias Column<Value> = ColumnProperty<Self, Value> where Value: Codable
    public typealias OptionalColumn<Value> = OptionalColumnProperty<Self, Value> where Value: Codable
    public typealias NestedColumn<Value> = NestedObjectProperty<Self, Value> where Value: Codable

    /// Table Name
    public static var schema: String { "\(Self.self)" }

    /// Path/Schema Name
    public static var path: String? { nil }

    public static func `as`(_ alias: String) -> TableAlias<Self> {
        .init(alias: alias)
    }

    public func `as`(_ alias: String) -> TableAlias<Self> {
        .init(alias: alias)
    }

    public static var table: Self { Self() }

    public static postfix func .* (table: Self) -> AllTableSelection<Self> {
        .init(table: table)
    }

    public var fromSqlExpression: some SQLExpression {
        _From(schemaName: Self.path, tableName: Self.schema)
    }

    // MARK: - ColumnProperty

    public static subscript<T>(
        dynamicMember keyPath: KeyPath<Self, Column<T>>
    ) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            schemaName: Self.path,
            tableName: Self.schema,
            columnName: field.key
        )
    }

    // MARK: - OptionalColumnProperty

    public static subscript<T>(
        dynamicMember keyPath: KeyPath<Self, OptionalColumn<T>>
    ) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            schemaName: Self.path,
            tableName: Self.schema,
            columnName: field.key
        )
    }

    // MARK: - NestedColumnProperty

    public static subscript<T>(
        dynamicMember keyPath: KeyPath<Self, NestedObjectProperty<Self, T>>
    ) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            schemaName: Self.path,
            tableName: Self.schema,
            columnName: field.key
        )
    }
}

struct _From: SQLExpression {
    let schemaName: String?
    let tableName: String

    func serialize(to serializer: inout SQLSerializer) {
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
