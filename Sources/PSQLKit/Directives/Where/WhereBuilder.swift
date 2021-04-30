import Foundation

typealias WhereBuilder = Builder<WhereSQLExpression>

extension Builder where T == WhereSQLExpression {
    public static func buildExpression<T>(
        _ expression: T
    ) -> Component where T: WhereSQLExpression {
        [expression]
    }
}
