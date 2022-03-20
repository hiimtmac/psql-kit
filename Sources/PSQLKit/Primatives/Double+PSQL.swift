// Double+PSQL.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

extension Double: PSQLExpression {
    public static var postgresColumnType: PostgresColumnType { .decimal }
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
    public var baseSqlExpression: SQLExpression { self }
}

extension Double: Concatenatable {}
extension Double: Coalescable {}

extension Double: SelectSQLExpression {
    public var selectSqlExpression: SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension Double: CompareSQLExpression {
    public var compareSqlExpression: SQLExpression { self }
}

extension Double: MutationSQLExpression {
    public var mutationSqlExpression: SQLExpression { self }
}
