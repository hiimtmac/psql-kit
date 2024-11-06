//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-04.
//

import PSQLKit
import FluentKit

extension Table where Self: Model {
    public static var path: String? { space }
    
    // MARK: - FieldProperty

    public static subscript<T>(
        dynamicMember keyPath: KeyPath<Self, FieldProperty<Self, T>>
    ) -> ColumnExpression<T> {
        let field = Self()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: nil,
            schemaName: Self.space,
            tableName: Self.schema,
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
            schemaName: Self.space,
            tableName: Self.schema,
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
            schemaName: Self.space,
            tableName: Self.schema,
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
            schemaName: Self.space,
            tableName: Self.schema,
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
            schemaName: Self.space,
            tableName: Self.schema,
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
            schemaName: Self.space,
            tableName: Self.schema,
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
            schemaName: Self.space,
            tableName: Self.schema,
            columnName: field.key.description
        )
    }
}
