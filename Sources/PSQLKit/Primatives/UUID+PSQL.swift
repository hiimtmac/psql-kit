import Foundation
import SQLKit
import PostgresKit

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

extension UUID: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        RawValue(self).selectSqlExpression
    }
}

extension UUID: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension UUID: MutationSQLExpression {
    public var mutationSqlExpression: some SQLExpression { self }
}
