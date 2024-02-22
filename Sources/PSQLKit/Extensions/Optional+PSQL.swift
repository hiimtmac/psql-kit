// Optional+PSQL.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

extension Optional: SQLExpression where Wrapped: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        if let self = self {
            self.serialize(to: &serializer)
        } else {
            serializer.write("NULL")
        }
    }
}

extension Optional: TypeEquatable where Wrapped: TypeEquatable {
    public typealias CompareType = Wrapped
}

extension Optional: PSQLExpression where Wrapped: PSQLExpression {
    public static var postgresDataType: PostgresDataType {
        Wrapped.postgresDataType
    }
}

extension Optional: SelectSQLExpression where Wrapped: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self?.selectSqlExpression }
    public var isNull: Bool { self == nil }
}

extension Optional: CompareSQLExpression where Wrapped: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self?.compareSqlExpression }
}

extension Optional: WhereSQLExpression where Wrapped: WhereSQLExpression {
    public var whereSqlExpression: some SQLExpression { self?.whereSqlExpression }
}
