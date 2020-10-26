import Foundation
import SQLKit
import PostgresKit

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
    public static var postgresColumnType: PostgresColumnType {
        Wrapped.postgresColumnType
    }
}

extension Optional: SelectSQLExpression where Wrapped: SQLExpression & SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension Optional: CompareSQLExpression where Wrapped: SQLExpression & CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension Optional: WhereSQLExpression where Wrapped: SQLExpression & WhereSQLExpression {
    public var whereSqlExpression: some SQLExpression { self }
}
