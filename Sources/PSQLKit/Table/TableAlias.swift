// TableAlias.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

@dynamicMemberLookup
public struct TableAlias<T>: Sendable where T: Table {
    public let alias: String

    init(alias: String) {
        self.alias = alias
    }
}

extension TableAlias {
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

extension TableAlias: FromSQLExpression {
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

        init(aliasName: String, schemaName: String?, tableName: String) {
            self.aliasName = aliasName
            self.schemaName = schemaName
            self.tableName = tableName
        }

        func serialize(to serializer: inout SQLSerializer) {
            if let path = schemaName {
                serializer.writeIdentifier(path)
                serializer.writePeriod()
            }

            serializer.writeIdentifier(self.tableName)

            serializer.writeSpaced("AS")

            serializer.writeIdentifier(self.aliasName)
        }
    }
}
