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

extension Double: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self)
    }
}

extension Double: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}
