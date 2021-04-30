import Foundation

typealias JoinBuilder = Builder<JoinSQLExpression>

extension Builder where T == JoinSQLExpression {
    public static func buildExpression<T>(
        _ expression: T
    ) -> Component where T: JoinSQLExpression {
        [expression]
    }
}
