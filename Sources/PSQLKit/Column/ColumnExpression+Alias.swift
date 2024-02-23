// ColumnExpression+Alias.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

extension ColumnExpression {
    public struct Alias {
        let column: ColumnExpression<T>
        let alias: String
    }

    public func `as`(_ alias: String) -> ColumnExpression<T>.Alias {
        Alias(column: self, alias: alias)
    }
}

extension ColumnExpression.Alias: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}

// MARK: Base

extension ColumnExpression.Alias: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        _Base(
            aliasName: column.aliasName,
            spaceName: column.spaceName,
            schemaName: column.schemaName,
            columnName: column.columnName,
            columnAlias: alias
        )
    }

    private struct _Base: SQLExpression {
        let aliasName: String?
        let spaceName: String?
        let schemaName: String?
        let columnName: String
        let columnAlias: String

        func serialize(to serializer: inout SQLSerializer) {
            if let alias = aliasName {
                serializer.writeQuote()
                serializer.write(alias)
                serializer.writeQuote()
                serializer.writePeriod()
            } else {
                if let space = spaceName {
                    serializer.writeQuote()
                    serializer.write(space)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }

                if let schema = schemaName {
                    serializer.writeQuote()
                    serializer.write(schema)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }
            }

            serializer.writeQuote()
            serializer.write(self.columnName)
            serializer.writeQuote()

            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()

            serializer.writeQuote()
            serializer.write(self.columnAlias)
            serializer.writeQuote()
        }
    }
}

// MARK: Select

extension ColumnExpression.Alias: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Select(
            aliasName: column.aliasName,
            spaceName: column.spaceName,
            schemaName: column.schemaName,
            columnName: column.columnName,
            dataType: T.postgresDataType,
            columnAlias: alias
        )
    }

    private struct _Select: SQLExpression {
        let aliasName: String?
        let spaceName: String?
        let schemaName: String?
        let columnName: String
        let dataType: PostgresDataType
        let columnAlias: String

        func serialize(to serializer: inout SQLSerializer) {
            if let alias = aliasName {
                serializer.writeQuote()
                serializer.write(alias)
                serializer.writeQuote()
                serializer.writePeriod()
            } else {
                if let space = spaceName {
                    serializer.writeQuote()
                    serializer.write(space)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }

                if let schema = schemaName {
                    serializer.writeQuote()
                    serializer.write(schema)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }
            }

            serializer.writeQuote()
            serializer.write(self.columnName)
            serializer.writeQuote()

            dataType.serialize(to: &serializer)

            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()

            serializer.writeQuote()
            serializer.write(self.columnAlias)
            serializer.writeQuote()
        }
    }
}

extension ColumnExpression.Alias: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression {
        _Mutation(
            aliasName: column.aliasName,
            spaceName: column.spaceName,
            schemaName: column.schemaName,
            columnName: column.columnName,
            dataType: T.postgresDataType,
            columnAlias: alias
        )
    }

    private struct _Mutation: SQLExpression {
        let aliasName: String?
        let spaceName: String?
        let schemaName: String?
        let columnName: String
        let dataType: PostgresDataType
        let columnAlias: String

        func serialize(to serializer: inout SQLSerializer) {
            if let alias = aliasName {
                serializer.writeQuote()
                serializer.write(alias)
                serializer.writeQuote()
                serializer.writePeriod()
            } else {
                if let space = spaceName {
                    serializer.writeQuote()
                    serializer.write(space)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }

                if let schema = schemaName {
                    serializer.writeQuote()
                    serializer.write(schema)
                    serializer.writeQuote()
                    serializer.writePeriod()
                }
            }

            serializer.writeQuote()
            serializer.write(self.columnName)
            serializer.writeQuote()

            self.dataType.serialize(to: &serializer)

            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()

            serializer.writeQuote()
            serializer.write(self.columnAlias)
            serializer.writeQuote()
        }
    }
}

extension ColumnExpression.Alias: Coalescable {}

extension ColumnExpression.Alias: Concatenatable where T: CustomStringConvertible {}

extension ColumnExpression.Alias: JsonbExtractable where T: Codable {}
