// AllTableSelection.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct AllCTESelection<T>: Sendable where T: CTE {
    let cte: T
}

// MARK: Select

extension AllCTESelection: SelectSQLExpression {
    struct _Select: SQLExpression {
        let schemaName: String?
        let tableName: String

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
        let cte: CTEAlias<T>
    }
}

extension AllCTESelection.Alias: SelectSQLExpression {
    struct _Select: SQLExpression {
        let aliasName: String

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

public struct AllTableSelection<T: Sendable>: Sendable where T: Table {
    let table: T
}

// MARK: Select

extension AllTableSelection: SelectSQLExpression {
    struct _Select: SQLExpression {
        let schemaName: String?
        let tableName: String

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
        _Select(schemaName: T.path, tableName: T.schema)
    }
}

// MARK: - Alias

extension AllTableSelection {
    public struct Alias: Sendable {
        let table: TableAlias<T>
    }
}

extension AllTableSelection.Alias: SelectSQLExpression {
    struct _Select: SQLExpression {
        let aliasName: String

        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(self.aliasName)
            serializer.writeQuote()
            serializer.writePeriod()
            serializer.write("*")
        }
    }

    public var selectSqlExpression: some SQLExpression {
        _Select(aliasName: self.table.alias)
    }
}
