import Foundation

typealias InsertBuilder = Builder<InsertSQLExpression>

extension Builder where T == InsertSQLExpression {
    public static func buildExpression<T>(
        _ expression: T
    ) -> Component where T: InsertSQLExpression {
        [expression]
    }
}
