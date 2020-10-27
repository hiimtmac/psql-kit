import Foundation
import SQLKit
import PostgresKit

extension String: PSQLExpression {
    public static var postgresColumnType: PostgresColumnType { .text }
}

extension String: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("'")
        serializer.write("\(self)")
        serializer.write("'")
    }
}

extension String: TypeEquatable {
    public typealias CompareType = Self
}

extension String: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension String: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}
