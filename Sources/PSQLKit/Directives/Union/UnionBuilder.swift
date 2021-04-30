import Foundation

typealias UnionBuilder = Builder<UnionSQLExpression>

extension Builder where T == UnionSQLExpression {
    public static func buildExpression<T>(
        _ expression: T
    ) -> Component where T: UnionSQLExpression {
        [expression]
    }
}
