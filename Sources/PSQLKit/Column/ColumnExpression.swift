// ColumnExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct ColumnExpression<T> where T: PSQLExpression {
    let aliasName: String?
    let pathName: String?
    let schemaName: String?
    let columnName: String

    public init(
        aliasName: String?,
        pathName: String?,
        schemaName: String?,
        columnName: String
    ) {
        self.aliasName = aliasName
        self.pathName = pathName
        self.schemaName = schemaName
        self.columnName = columnName
    }
}

// MARK: Base

extension ColumnExpression: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        _Base(
            aliasName: self.aliasName,
            pathName: self.pathName,
            schemaName: self.schemaName,
            columnName: self.columnName
        )
    }

    private struct _Base: SQLExpression {
        let aliasName: String?
        let pathName: String?
        let schemaName: String?
        let columnName: String

        func serialize(to serializer: inout SQLSerializer) {
            if let alias = aliasName {
                serializer.writeQuote()
                serializer.write(alias)
                serializer.writeQuote()
                serializer.writePeriod()
            } else {
                if let path = pathName {
                    serializer.writeQuote()
                    serializer.write(path)
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
        }
    }
}

// MARK: Select

extension ColumnExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Select(
            aliasName: self.aliasName,
            pathName: self.pathName,
            schemaName: self.schemaName,
            columnName: self.columnName,
            dataType: T.postgresDataType
        )
    }

    private struct _Select: SQLExpression {
        let aliasName: String?
        let pathName: String?
        let schemaName: String?
        let columnName: String
        let dataType: PostgresDataType

        func serialize(to serializer: inout SQLSerializer) {
            if let alias = aliasName {
                serializer.writeQuote()
                serializer.write(alias)
                serializer.writeQuote()
                serializer.writePeriod()
            } else {
                if let path = pathName {
                    serializer.writeQuote()
                    serializer.write(path)
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
        }
    }
}

// MARK: Transform

extension ColumnExpression {
    public func transform<U>(to _: U.Type) -> ColumnExpression<U> where U: PSQLExpression {
        ColumnExpression<U>(
            aliasName: self.aliasName,
            pathName: self.pathName,
            schemaName: self.schemaName,
            columnName: self.columnName
        )
    }
}

// MARK: Group By

extension ColumnExpression: GroupBySQLExpression {
    public var groupBySqlExpression: some SQLExpression {
        _Base(
            aliasName: self.aliasName,
            pathName: self.pathName,
            schemaName: self.schemaName,
            columnName: self.columnName
        )
    }
}

// MARK: Order By

extension ColumnExpression: OrderBySQLExpression {
    public var orderBySqlExpression: some SQLExpression {
        _Base(
            aliasName: self.aliasName,
            pathName: self.pathName,
            schemaName: self.schemaName,
            columnName: self.columnName
        )
    }

    public func asc() -> OrderByModifier<ColumnExpression<T>> {
        self.order(.asc)
    }

    public func desc() -> OrderByModifier<ColumnExpression<T>> {
        self.order(.desc)
    }

    public func order(_ direction: OrderByDirection) -> OrderByModifier<ColumnExpression<T>> {
        OrderByModifier(content: self, direction: direction)
    }
}

// MARK: Compare

extension ColumnExpression: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression {
        _Base(
            aliasName: self.aliasName,
            pathName: self.pathName,
            schemaName: self.schemaName,
            columnName: self.columnName
        )
    }
}

// MARK: Mutation

extension ColumnExpression: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression {
        _Mutation(columnName: self.columnName)
    }

    private struct _Mutation: SQLExpression {
        let columnName: String

        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(self.columnName)
            serializer.writeQuote()
        }
    }
}

// MARK: Equatable

extension ColumnExpression: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}

// MARK:

extension ColumnExpression where T == Date {
    public func `as`<U>(_: U.Type) -> ColumnExpression<U> where U: PSQLDateTime {
        ColumnExpression<U>(
            aliasName: self.aliasName,
            pathName: self.pathName,
            schemaName: self.schemaName,
            columnName: self.columnName
        )
    }
}

extension ColumnExpression: PSQLArrayRepresentable {}

extension ColumnExpression: Coalescable {}

extension ColumnExpression: Concatenatable where T: CustomStringConvertible {}

extension ColumnExpression: JsonbExtractable where T: Codable {}
