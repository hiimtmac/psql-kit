// Table.swift
// Copyright (c) 2024 hiimtmac inc.

import class FluentKit.FieldProperty
import class FluentKit.GroupProperty
import class FluentKit.IDProperty
import protocol FluentKit.Model
import class FluentKit.OptionalFieldProperty
import class FluentKit.OptionalParentProperty
import class FluentKit.ParentProperty
import class FluentKit.TimestampProperty
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

@dynamicMemberLookup
public protocol Table: FromSQLExpression {
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
        .init(path: self.path, alias: alias)
    }

    public func `as`(_ alias: String) -> TableAlias<Self> {
        .init(path: Self.path, alias: alias)
    }

    public static var table: Self { Self() }

    public static postfix func .* (table: Self) -> AllTableSelection<Self> {
        .init(table: table)
    }

    public var fromSqlExpression: some SQLExpression {
        _From(pathName: Self.path, schemaName: Self.schema)
    }

    // MARK: - ColumnProperty

    public static subscript<T>(
        dynamicMember keyPath: KeyPath<Self, Column<T>>
    ) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
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
            pathName: Self.path,
            schemaName: Self.schema,
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
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key
        )
    }
}

extension Table where Self: Model {
    // MARK: - FieldProperty

    public static subscript<T>(
        dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>
    ) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }

    // MARK: - OptionalFieldProperty

    public static subscript<T>(
        dynamicMember keyPath: KeyPath<Self, OptionalFieldProperty<Self, T>>
    ) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }

    // MARK: - IDProperty

    public static subscript<T>(
        dynamicMember keyPath: KeyPath<Self, IDProperty<Self, T>>
    ) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }

    // MARK: - ParentProperty

    public static subscript<T>(
        dynamicMember keyPath: KeyPath<Self, ParentProperty<Self, T>>
    ) -> ColumnExpression<T.IDValue> where T: Model {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.$id.key.description
        )
    }

    // MARK: - OptionalParentProperty

    public static subscript<T>(
        dynamicMember keyPath: KeyPath<Self, OptionalParentProperty<Self, T>>
    ) -> ColumnExpression<T.IDValue> where T: Model {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.$id.key.description
        )
    }

    // MARK: - TimestampProperty

    public static subscript<T>(
        dynamicMember keyPath: KeyPath<Self, TimestampProperty<Self, T>>
    ) -> ColumnExpression<T.Value> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.$timestamp.key.description
        )
    }

    // MARK: - GroupProperty

    public static subscript<T>(
        dynamicMember keyPath: KeyPath<Self, GroupProperty<Self, T>>
    ) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            pathName: Self.path,
            schemaName: Self.schema,
            columnName: field.key.description
        )
    }
}

private struct _From: SQLExpression {
    let pathName: String?
    let schemaName: String

    func serialize(to serializer: inout SQLSerializer) {
        if let path = pathName {
            serializer.writeQuote()
            serializer.write(path)
            serializer.writeQuote()
            serializer.writePeriod()
        }

        serializer.writeQuote()
        serializer.write(self.schemaName)
        serializer.writeQuote()
    }
}
