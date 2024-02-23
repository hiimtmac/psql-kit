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
    public var selectIsNull: Bool { self == nil }
}

extension Optional: HavingSQLExpression where Wrapped: HavingSQLExpression {
    public var havingSqlExpression: some SQLExpression { self?.havingSqlExpression }
    public var havingIsNull: Bool { self == nil }
}

extension Optional: GroupBySQLExpression where Wrapped: GroupBySQLExpression {
    public var groupBySqlExpression: some SQLExpression { self?.groupBySqlExpression }
    public var groupByIsNull: Bool { self == nil }
}

extension Optional: WithSQLExpression where Wrapped: WithSQLExpression {
    public var withSqlExpression: some SQLExpression { self?.withSqlExpression }
    public var withIsNull: Bool { self == nil }
}

extension Optional: CompareSQLExpression where Wrapped: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self?.compareSqlExpression }
}

extension Optional: WhereSQLExpression where Wrapped: WhereSQLExpression {
    public var whereSqlExpression: some SQLExpression { self?.whereSqlExpression }
}
