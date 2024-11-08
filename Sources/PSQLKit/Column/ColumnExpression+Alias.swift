// ColumnExpression+Alias.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

extension ColumnExpression {
    public struct Alias: Sendable {
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
            schemaName: column.schemaName,
            tableName: column.tableName,
            columnName: column.columnName,
            columnAlias: alias
        )
    }

    struct _Base: SQLExpression {
        let aliasName: String?
        let schemaName: String?
        let tableName: String?
        let columnName: String
        let columnAlias: String

        func serialize(to serializer: inout SQLSerializer) {
            if let alias = aliasName {
                serializer.writeQuoted(alias)
                serializer.writePeriod()
            } else {
                if let space = schemaName {
                    serializer.writeQuoted(space)
                    serializer.writePeriod()
                }

                if let schema = tableName {
                    serializer.writeQuoted(schema)
                    serializer.writePeriod()
                }
            }

            serializer.writeQuoted(self.columnName)

            serializer.writeSpaced("AS")

            serializer.writeQuoted(self.columnAlias)
        }
    }
}

// MARK: Select

extension ColumnExpression.Alias: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Select(
            aliasName: column.aliasName,
            schemaName: column.schemaName,
            tableName: column.tableName,
            columnName: column.columnName,
            dataType: T.postgresDataType,
            columnAlias: alias
        )
    }

    struct _Select: SQLExpression {
        let aliasName: String?
        let schemaName: String?
        let tableName: String?
        let columnName: String
        let dataType: PostgresDataType
        let columnAlias: String

        func serialize(to serializer: inout SQLSerializer) {
            if let alias = aliasName {
                serializer.writeQuoted(alias)
                serializer.writePeriod()
            } else {
                if let space = schemaName {
                    serializer.writeQuoted(space)
                    serializer.writePeriod()
                }

                if let schema = tableName {
                    serializer.writeQuoted(schema)
                    serializer.writePeriod()
                }
            }

            serializer.writeQuoted(self.columnName)

            dataType.serialize(to: &serializer)

            serializer.writeSpaced("AS")

            serializer.writeQuoted(self.columnAlias)
        }
    }
}

extension ColumnExpression.Alias: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression {
        _Mutation(
            aliasName: column.aliasName,
            schemaName: column.schemaName,
            tableName: column.tableName,
            columnName: column.columnName,
            dataType: T.postgresDataType,
            columnAlias: alias
        )
    }

    struct _Mutation: SQLExpression {
        let aliasName: String?
        let schemaName: String?
        let tableName: String?
        let columnName: String
        let dataType: PostgresDataType
        let columnAlias: String

        func serialize(to serializer: inout SQLSerializer) {
            if let alias = aliasName {
                serializer.writeQuoted(alias)
                serializer.writePeriod()
            } else {
                if let space = schemaName {
                    serializer.writeQuoted(space)
                    serializer.writePeriod()
                }

                if let schema = tableName {
                    serializer.writeQuoted(schema)
                    serializer.writePeriod()
                }
            }

            serializer.writeQuoted(self.columnName)

            self.dataType.serialize(to: &serializer)

            serializer.writeSpaced("AS")

            serializer.writeQuoted(self.columnAlias)
        }
    }
}

extension ColumnExpression.Alias: Coalescable {}

extension ColumnExpression.Alias: Concatenatable where T: CustomStringConvertible {}

extension ColumnExpression.Alias: JsonbExtractable where T: Codable {}
