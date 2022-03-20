// UUID+PSQL.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

extension UUID: PSQLExpression {
    public static var postgresColumnType: PostgresColumnType { .uuid }
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
    public var baseSqlExpression: SQLExpression { self }
}

extension UUID: Concatenatable {}
extension UUID: Coalescable {}

extension UUID: SelectSQLExpression {
    public var selectSqlExpression: SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension UUID: CompareSQLExpression {
    public var compareSqlExpression: SQLExpression { self }
}

extension UUID: MutationSQLExpression {
    public var mutationSqlExpression: SQLExpression { self }
}
