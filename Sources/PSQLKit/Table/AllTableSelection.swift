// AllTableSelection.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct AllTableSelection<T> where T: Table {
    let table: T
}

// MARK: Select

extension AllTableSelection: SelectSQLExpression {
    private struct _Select: SQLExpression {
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
            serializer.writePeriod()
            serializer.write("*")
        }
    }

    public var selectSqlExpression: some SQLExpression {
        _Select(pathName: T.path, schemaName: T.schema)
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
