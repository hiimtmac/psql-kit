// TableAlias.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

@dynamicMemberLookup
public struct CTEAlias<T>: Sendable where T: CTE {
    public let alias: String
    
    init(alias: String) {
        self.alias = alias
    }
}

extension CTEAlias {
    public subscript<U>(
        dynamicMember keyPath: KeyPath<T.QueryContainer, ColumnAccessor<U>>
    ) -> ColumnExpression<U> where U: PSQLExpression {
        let field = T.queryContainer[keyPath: keyPath]
        return ColumnExpression(
            aliasName: self.alias,
            schemaName: T.schemaName,
            tableName: T.tableName,
            columnName: field.column
        )
    }
    
    public static postfix func .* (_ alias: Self) -> AllCTESelection<T>.Alias {
        .init(cte: alias)
    }
    
    public var table: Self { self }
}

extension CTEAlias: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression {
        _From(
            aliasName: self.alias,
            schemaName: T.schemaName,
            tableName: T.tableName
        )
    }

    struct _From: SQLExpression {
        let aliasName: String
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

            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()

            serializer.writeQuote()
            serializer.write(self.aliasName)
            serializer.writeQuote()
        }
    }
}

@dynamicMemberLookup
public struct TableAlias<T: Sendable>: Sendable where T: Table {
    /// table alias
    public let alias: String

    init(alias: String) {
        self.alias = alias
    }
}

extension TableAlias {
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
            schemaName: T.path,
            tableName: T.schema,
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
            schemaName: T.path,
            tableName: T.schema,
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
            schemaName: T.path,
            tableName: T.schema,
            columnName: field.key
        )
    }
}

extension TableAlias: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression {
        _From(
            aliasName: self.alias,
            schemaName: T.path,
            tableName: T.schema
        )
    }

    struct _From: SQLExpression {
        let aliasName: String
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

            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()

            serializer.writeQuote()
            serializer.write(self.aliasName)
            serializer.writeQuote()
        }
    }
}
