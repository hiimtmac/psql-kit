// RawColumn.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct RawColumn<T> where T: PSQLExpression {
    let column: String

    public init(_ column: String) {
        self.column = column
    }
}

extension RawColumn {
    public func `as`(_ alias: String) -> RawColumn<T>.Alias {
        Alias(column: self, alias: alias)
    }
}

extension RawColumn: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension RawColumn: SelectSQLExpression {
    private struct _Select: SQLExpression {
        let column: String
        let dataType: PostgresDataType

        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(self.column)
            serializer.writeQuote()
            self.dataType.serialize(to: &serializer)
        }
    }

    public var selectSqlExpression: some SQLExpression {
        _Select(column: self.column, dataType: T.postgresDataType)
    }
}

extension RawColumn: GroupBySQLExpression {
    private struct _GroupBy: SQLExpression {
        let column: String

        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(self.column)
            serializer.writeQuote()
        }
    }

    public var groupBySqlExpression: some SQLExpression {
        _GroupBy(column: self.column)
    }
}

extension RawColumn: OrderBySQLExpression {
    private struct _OrderBy: SQLExpression {
        let column: String

        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(self.column)
            serializer.writeQuote()
        }
    }

    public var orderBySqlExpression: some SQLExpression {
        _OrderBy(column: self.column)
    }

    public func asc() -> OrderByModifier<RawColumn> {
        self.order(.asc)
    }

    public func desc() -> OrderByModifier<RawColumn> {
        self.order(.desc)
    }

    public func order(_ direction: OrderByDirection) -> OrderByModifier<RawColumn> {
        .init(content: self, direction: direction)
    }
}

extension RawColumn: CompareSQLExpression {
    private struct _Compare: SQLExpression {
        let column: String

        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(self.column)
            serializer.writeQuote()
        }
    }

    public var compareSqlExpression: some SQLExpression {
        _Compare(column: self.column)
    }
}

// MARK: - Alias

extension RawColumn {
    public struct Alias {
        let column: RawColumn<T>
        let alias: String

        public init(column: RawColumn<T>, alias: String) {
            self.column = column
            self.alias = alias
        }
    }
}

extension RawColumn.Alias: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension RawColumn.Alias: SelectSQLExpression {
    private struct _Select: SQLExpression {
        let column: RawColumn<T>
        let alias: String

        func serialize(to serializer: inout SQLSerializer) {
            self.column.selectSqlExpression.serialize(to: &serializer)

            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()

            serializer.writeQuote()
            serializer.write(self.alias)
            serializer.writeQuote()
        }
    }

    public var selectSqlExpression: some SQLExpression {
        _Select(column: self.column, alias: alias)
    }
}
