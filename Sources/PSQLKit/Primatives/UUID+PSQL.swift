// UUID+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

extension UUID: PSQLExpression {
    public static var postgresDataType: PostgresDataType { .uuid }
}

extension UUID: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("'")
        serializer.write("\(self.uuidString)")
        serializer.write("'")
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
        RawValue._Select(value: self)
    }
}

extension UUID: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension UUID: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}
