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
        _TableAliasFrom(
            aliasName: self.alias,
            schemaName: T.schemaName,
            tableName: T.tableName
        )
    }
}

package struct _TableAliasFrom: SQLExpression {
    let aliasName: String
    let schemaName: String?
    let tableName: String
    
    package init(aliasName: String, schemaName: String?, tableName: String) {
        self.aliasName = aliasName
        self.schemaName = schemaName
        self.tableName = tableName
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

        serializer.writeSpace()
        serializer.write("AS")
        serializer.writeSpace()

        serializer.writeQuote()
        serializer.write(self.aliasName)
        serializer.writeQuote()
    }
}
