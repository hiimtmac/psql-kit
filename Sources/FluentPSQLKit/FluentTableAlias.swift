// FluentTableAlias.swift
// Copyright (c) 2024 hiimtmac inc.

import FluentKit
import PSQLKit
import SQLKit

@dynamicMemberLookup
public struct FluentCTEAlias<T>: Sendable where T: FluentCTE {
    public let alias: String

    init(alias: String) {
        self.alias = alias
    }
}

extension FluentCTEAlias {
    public var table: Self { self }

    public static postfix func .* (_ alias: Self) -> AllFluentCTESelection<T>.Alias {
        .init(cte: alias)
    }
}

extension FluentCTEAlias: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression {
        _TableAliasFrom(
            aliasName: self.alias,
            schemaName: T.space,
            tableName: T.schema
        )
    }
}

extension FluentCTEAlias {
    // MARK: - FieldProperty

    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>
    ) -> ColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            schemaName: T.space,
            tableName: T.schema,
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
            schemaName: T.space,
            tableName: T.schema,
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
            schemaName: T.space,
            tableName: T.schema,
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
            schemaName: T.space,
            tableName: T.schema,
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
            schemaName: T.space,
            tableName: T.schema,
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
            schemaName: T.space,
            tableName: T.schema,
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
            schemaName: T.space,
            tableName: T.schema,
            columnName: field.key.description
        )
    }
}
