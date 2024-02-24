// AllTableSelection.swift
// Copyright (c) 2024 hiimtmac inc.

import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct AllTableSelection<T> where T: Table {
    let table: T
}

// MARK: Select

extension AllTableSelection: SelectSQLExpression {
    private struct _Select: SQLExpression {
        let spaceName: String?
        let schemaName: String

        func serialize(to serializer: inout SQLSerializer) {
            if let space = spaceName {
                serializer.writeQuote()
                serializer.write(space)
                serializer.writeQuote()
                serializer.writePeriod()
            }

            serializer.writeQuote()
            serializer.write(self.schemaName)
            serializer.writeQuote()
            serializer.writePeriod()
            serializer.write("*")
        }
    }

    public var selectSqlExpression: some SQLExpression {
        _Select(spaceName: T.path, schemaName: T.schema)
    }
}

// MARK: - Alias

extension AllTableSelection {
    public struct Alias {
        let table: TableAlias<T>
    }
}

extension AllTableSelection.Alias: SelectSQLExpression {
    private struct _Select: SQLExpression {
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
