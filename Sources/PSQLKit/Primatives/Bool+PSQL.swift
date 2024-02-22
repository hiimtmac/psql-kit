// Bool+PSQL.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

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
    public var baseSqlExpression: SQLExpression { self }
}

extension Bool: Concatenatable {}
extension Bool: Coalescable {}

extension Bool: SelectSQLExpression {
    public var selectSqlExpression: SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension Bool: CompareSQLExpression {
    public var compareSqlExpression: SQLExpression { self }
}

extension Bool: JoinSQLExpression {
    public var joinSqlExpression: SQLExpression { self }
}

extension Bool: MutationSQLExpression {
    public var mutationSqlExpression: SQLExpression { self }
}
