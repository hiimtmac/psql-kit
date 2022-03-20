// Int+PSQL.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

extension Int: PSQLExpression {
    public static var postgresColumnType: PostgresColumnType { .integer }
}

extension Int: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Int: TypeEquatable {
    public typealias CompareType = Self
}

extension Int: BaseSQLExpression {
    public var baseSqlExpression: SQLExpression { self }
}

extension Int: Concatenatable {}
extension Int: Coalescable {}

extension Int: SelectSQLExpression {
    public var selectSqlExpression: SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension Int: CompareSQLExpression {
    public var compareSqlExpression: SQLExpression { self }
}

extension Int: MutationSQLExpression {
    public var mutationSqlExpression: SQLExpression { self }
}
