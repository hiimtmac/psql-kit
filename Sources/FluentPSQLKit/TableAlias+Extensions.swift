//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-04.
//

import PSQLKit
import FluentKit

extension TableAlias where T: Model {
    // MARK: - FieldProperty

    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>
    ) -> ColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            spaceName: T.space,
            schemaName: T.schema,
            columnName: field.key.description
        )
    }

    // MARK: - OptionalFieldProperty

    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, OptionalFieldProperty<T, U>>
    ) -> ColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            spaceName: T.space,
            schemaName: T.schema,
            columnName: field.key.description
        )
    }

    // MARK: - IDProperty

    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, IDProperty<T, U>>
    ) -> ColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            spaceName: T.space,
            schemaName: T.schema,
            columnName: field.key.description
        )
    }

    // MARK: - ParentProperty

    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, ParentProperty<T, U>>
    ) -> ColumnExpression<U.IDValue> where U: Model {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            spaceName: T.space,
            schemaName: T.schema,
            columnName: field.$id.key.description
        )
    }

    // MARK: - OptionalParentProperty

    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, OptionalParentProperty<T, U>>
    ) -> ColumnExpression<U.IDValue> where T: Model {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            spaceName: T.space,
            schemaName: T.schema,
            columnName: field.$id.key.description
        )
    }

    // MARK: - TimestampProperty

    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, TimestampProperty<T, U>>
    ) -> ColumnExpression<U.Value> where T: Model {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            spaceName: T.space,
            schemaName: T.schema,
            columnName: field.$timestamp.key.description
        )
    }

    // MARK: - GroupProperty

    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, GroupProperty<T, U>>
    ) -> ColumnExpression<U> where T: Model {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            spaceName: T.space,
            schemaName: T.schema,
            columnName: field.key.description
        )
    }
}
