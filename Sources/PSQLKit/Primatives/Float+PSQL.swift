import Foundation
import SQLKit
import PostgresKit

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

extension Float: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self)
    }
}

extension Float: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}
