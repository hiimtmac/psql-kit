// String+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

extension String: PSQLExpression {
    public static var postgresDataType: PostgresDataType { .text }
}

extension String: @retroactive SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.writeLiteral(self)
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
