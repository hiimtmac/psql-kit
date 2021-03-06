import Foundation
import SQLKit
import PostgresKit

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
    public var baseSqlExpression: some SQLExpression { self }
}

extension Int: Concatenatable {}
extension Int: Coalescable {}

extension Int: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension Int: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension Int: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}
