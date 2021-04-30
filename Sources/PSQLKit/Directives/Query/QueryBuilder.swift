import Foundation

typealias QueryBuilder = Builder<QuerySQLExpression>

extension Builder where T == QuerySQLExpression {
    public static func buildExpression<T>(
        _ expression: T
    ) -> Component where T: QuerySQLExpression {
        [expression]
    }
}
