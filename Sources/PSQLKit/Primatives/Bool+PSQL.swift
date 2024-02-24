// Bool+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

extension Bool: PSQLExpression {
    public static var postgresDataType: PostgresDataType { .bool }
}

extension Bool: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Bool: TypeEquatable {
    public typealias CompareType = Self
}

extension Bool: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression { self }
}

extension Bool: Concatenatable {}
extension Bool: Coalescable {}

extension Bool: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension Bool: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension Bool: JoinSQLExpression {
    public var joinSqlExpression: some SQLExpression { self }
}

extension Bool: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}
