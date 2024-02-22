// TableAlias.swift
// Copyright © 2022 hiimtmac

import FluentKit
import Foundation
import SQLKit

@dynamicMemberLookup
public struct TableAlias<T> where T: Table {
    /// psql `schema`
    let path: String?
    /// table alias
    let alias: String

    init(path: String?, alias: String) {
        self.alias = alias
        self.path = path ?? T.path
    }
}

extension TableAlias {
    func schema(_ schema: String) -> Self {
        .init(path: schema, alias: self.alias)
    }

    public var table: TableAlias { self }

    public static postfix func .* (_ alias: Self) -> AllTableSelection<T>.Alias {
        .init(table: alias)
    }

    // MARK: - ColumnProperty

    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, ColumnProperty<T, U>>
    ) -> ColumnExpression<U> where U: PSQLExpression {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            pathName: self.path,
            schemaName: T.schema,
            columnName: field.key
        )
    }

    // MARK: - OptionalColumnProperty

    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, OptionalColumnProperty<T, U>>
    ) -> ColumnExpression<U> where U: PSQLExpression {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            pathName: self.path,
            schemaName: T.schema,
            columnName: field.key
        )
    }

    // MARK: - NestedColumnProperty

    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, NestedObjectProperty<T, U>>
    ) -> ColumnExpression<U> where U: PSQLExpression {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            pathName: self.path,
            schemaName: T.schema,
            columnName: field.key
        )
    }
}

extension TableAlias where T: Model {
    // MARK: - FieldProperty

    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, FieldProperty<T, U>>
    ) -> ColumnExpression<U> {
        let field = T()[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            pathName: self.path,
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
            pathName: self.path,
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
            pathName: self.path,
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
            pathName: self.path,
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
            pathName: self.path,
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
            pathName: self.path,
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
            pathName: self.path,
            schemaName: T.schema,
            columnName: field.key.description
        )
    }
}

extension TableAlias: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression {
        _From(
            aliasName: self.alias,
            pathName: T.path,
            schemaName: T.schema
        )
    }

    private struct _From: SQLExpression {
        let aliasName: String
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

            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()

            serializer.writeQuote()
            serializer.write(self.aliasName)
            serializer.writeQuote()
        }
    }
}
