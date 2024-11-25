//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-25.
//

import SQLKit
import PostgresNIO

public struct ColumnDefinition: Sendable, SQLExpression {
    let column: String
    let dataType: PostgresDataType
    
    public init(_ name: String, type: PostgresDataType) {
        self.column = name
        self.dataType = type
    }
    
    public init<T>(_ name: String, type: T.Type) where T: PSQLExpression {
        self.column = name
        self.dataType = T.postgresDataType
    }
    
    public init<T>(_ column: ColumnExpression<T>) where T: PSQLExpression {
        self.column = column.columnName
        self.dataType = T.postgresDataType
    }
    
    public init<T>(_ alias: ColumnExpression<T>.Alias) where T: PSQLExpression {
        self.column = alias.alias
        self.dataType = T.postgresDataType
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.writeIdentifier(column)
        if let knownSQLName = dataType.knownSQLName {
            serializer.writeSpace()
            serializer.write(knownSQLName)
        }
    }
}
