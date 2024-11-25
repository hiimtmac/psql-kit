// RawColumn.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

public struct RawColumn<T>: Sendable where T: PSQLExpression {
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
    struct _Select: SQLExpression {
        let column: String
        let dataType: PostgresDataType

        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeIdentifier(self.column)
            serializer.writeCast(dataType)
        }
    }

    public var selectSqlExpression: some SQLExpression {
        _Select(column: self.column, dataType: T.postgresDataType)
    }
}

extension RawColumn: GroupBySQLExpression {
    struct _GroupBy: SQLExpression {
        let column: String

        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeIdentifier(self.column)
        }
    }

    public var groupBySqlExpression: some SQLExpression {
        _GroupBy(column: self.column)
    }
}

extension RawColumn: OrderBySQLExpression {
    struct _OrderBy: SQLExpression {
        let column: String

        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeIdentifier(self.column)
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
    struct _Compare: SQLExpression {
        let column: String

        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeIdentifier(self.column)
        }
    }

    public var compareSqlExpression: some SQLExpression {
        _Compare(column: self.column)
    }
}

// MARK: - Alias

extension RawColumn {
    public struct Alias: Sendable {
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
    struct _Select: SQLExpression {
        let column: RawColumn<T>
        let alias: String

        func serialize(to serializer: inout SQLSerializer) {
            self.column.selectSqlExpression.serialize(to: &serializer)

            serializer.writeSpaced("AS")

            serializer.writeIdentifier(self.alias)
        }
    }

    public var selectSqlExpression: some SQLExpression {
        _Select(column: self.column, alias: alias)
    }
}

extension String {
    public func `as`<T>(columnOf type: T.Type) -> RawColumn<T> where T: PSQLExpression {
        RawColumn(self)
    }
}
