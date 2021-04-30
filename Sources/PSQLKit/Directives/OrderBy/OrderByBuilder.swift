import Foundation

typealias OrderByBuilder = Builder<OrderBySQLExpression>

extension Builder where T == OrderBySQLExpression {
    public static func buildExpression<T>(
        _ expression: T
    ) -> Component where T: OrderBySQLExpression {
        [expression]
    }
}
