// UUID+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import PostgresNIO
import SQLKit

extension UUID: PSQLExpression {
    public static var postgresDataType: PostgresDataType { .uuid }
}

extension UUID: @retroactive SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.writeLiteral(self.uuidString)
    }
}

extension UUID: TypeEquatable {
    public typealias CompareType = Self
}

extension UUID: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression { self }
}

extension UUID: Concatenatable {}
extension UUID: Coalescable {}

extension UUID: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension UUID: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension UUID: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}
