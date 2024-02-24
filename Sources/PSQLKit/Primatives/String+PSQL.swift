// String+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

extension String: PSQLExpression {
    public static var postgresDataType: PostgresDataType { .text }
}

extension String: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("'")
        serializer.write("\(self)")
        serializer.write("'")
    }
}

extension String: TypeEquatable {
    public typealias CompareType = Self
}

extension String: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression { self }
}

extension String: Concatenatable {}
extension String: Coalescable {}

extension String: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension String: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension String: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}
