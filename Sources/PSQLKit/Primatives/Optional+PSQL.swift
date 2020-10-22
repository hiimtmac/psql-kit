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

extension Optional: PSQLExpressible where Wrapped: PSQLExpressible {
    public static var postgresColumnType: PostgresColumnType { Wrapped.postgresColumnType }
}

extension Optional: SelectSQLExpressible where Wrapped: SQLExpression & SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension Optional: CompareSQLExpressible where Wrapped: SQLExpression & CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression { self }
}
