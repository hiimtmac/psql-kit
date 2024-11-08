// AllTableSelection.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct AllCTESelection<T>: Sendable where T: Table {
    let cte: CTETable<T>
}

// MARK: Select

extension AllCTESelection: SelectSQLExpression {
    struct _Select: SQLExpression {
        let schemaName: String?
        let tableName: String
        
        init(schemaName: String?, tableName: String) {
            self.schemaName = schemaName
            self.tableName = tableName
        }
        
        func serialize(to serializer: inout SQLSerializer) {
            if let space = schemaName {
                serializer.writeQuote()
                serializer.write(space)
                serializer.writeQuote()
                serializer.writePeriod()
            }
            
            serializer.writeQuote()
            serializer.write(self.tableName)
            serializer.writeQuote()
            serializer.writePeriod()
            serializer.write("*")
        }
    }

    public var selectSqlExpression: some SQLExpression {
        _Select(schemaName: T.schemaName, tableName: T.tableName)
    }
}

// MARK: - Alias

extension AllCTESelection {
    public struct Alias: Sendable {
        let cte: TableAlias<T>
    }
}

extension AllCTESelection.Alias: SelectSQLExpression {
    struct _Select: SQLExpression {
        let aliasName: String

        init(aliasName: String) {
            self.aliasName = aliasName
        }

        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(self.aliasName)
            serializer.writeQuote()
            serializer.writePeriod()
            serializer.write("*")
        }
    }
    
    public var selectSqlExpression: some SQLExpression {
        _Select(aliasName: self.cte.alias)
    }
}
