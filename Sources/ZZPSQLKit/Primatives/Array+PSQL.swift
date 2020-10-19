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
    typealias CompareType = Self
}

extension Array: PSQLExpressible where Element: PSQLExpressible {
    static var postgresColumnType: PostgresColumnType { .array(Element.postgresColumnType) }
}

extension Array: SelectSQLExpressible where Element: SQLExpression & SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

extension Array: CompareSQLExpressible where Element: SQLExpression & CompareSQLExpressible {
    var compareSqlExpression: Self { self }
}
