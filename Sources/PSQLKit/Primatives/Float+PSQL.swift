// Float+PSQL.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

extension Float: PSQLExpression {
    public static var postgresColumnType: PostgresColumnType { .decimal }
}

extension Float: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Float: TypeEquatable {
    public typealias CompareType = Self
}

extension Float: BaseSQLExpression {
    public var baseSqlExpression: SQLExpression { self }
}

extension Float: Concatenatable {}
extension Float: Coalescable {}

extension Float: SelectSQLExpression {
    public var selectSqlExpression: SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension Float: CompareSQLExpression {
    public var compareSqlExpression: SQLExpression { self }
}

extension Float: MutationSQLExpression {
    public var mutationSqlExpression: SQLExpression { self }
}
