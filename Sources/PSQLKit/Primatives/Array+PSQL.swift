import Foundation
import SQLKit
import PostgresKit

extension Array: SQLExpression where Element: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("(")
        SQLList(self).serialize(to: &serializer)
        serializer.write(")")
    }
}

extension Array: TypeEquatable where Element: TypeEquatable {
    public typealias CompareType = Self
}

extension Array: PSQLExpressible where Element: PSQLExpressible {
    public static var postgresColumnType: PostgresColumnType { .array(Element.postgresColumnType) }
}

extension Array: SelectSQLExpressible where Element: SQLExpression & SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension Array: CompareSQLExpressible where Element: SQLExpression & CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression { self }
}
