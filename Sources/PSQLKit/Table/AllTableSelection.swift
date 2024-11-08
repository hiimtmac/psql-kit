// AllTableSelection.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct AllCTESelection<T>: Sendable where T: CTE {
    let cte: CTETable<T>
}

// MARK: Select

package struct _AllTableSelect: SQLExpression {
    let schemaName: String?
    let tableName: String

    package init(schemaName: String?, tableName: String) {
        self.schemaName = schemaName
        self.tableName = tableName
    }

    package func serialize(to serializer: inout SQLSerializer) {
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

extension AllCTESelection: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _AllTableSelect(schemaName: T.schemaName, tableName: T.tableName)
    }
}

// MARK: - Alias

extension AllCTESelection {
    public struct Alias: Sendable {
        let cte: CTEAlias<T>
    }
}

extension AllCTESelection.Alias: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _AllTableSelectAlias(aliasName: self.cte.alias)
    }
}

package struct _AllTableSelectAlias: SQLExpression {
    let aliasName: String

    package init(aliasName: String) {
        self.aliasName = aliasName
    }

    package func serialize(to serializer: inout SQLSerializer) {
        serializer.writeQuote()
        serializer.write(self.aliasName)
        serializer.writeQuote()
        serializer.writePeriod()
        serializer.write("*")
    }
}
