// Double+PSQL.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer
import struct PostgresNIO.PostgresDataType

extension Double: PSQLExpression {
    public static var postgresDataType: PostgresDataType { .numeric }
}

extension Double: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Double: TypeEquatable {
    public typealias CompareType = Self
}

extension Double: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression { self }
}

extension Double: Concatenatable {}
extension Double: Coalescable {}

extension Double: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue._Select(value: self)
    }
}

extension Double: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension Double: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}
