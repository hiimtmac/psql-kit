import Foundation

typealias GroupByBuilder = Builder<GroupBySQLExpression>

extension Builder where T == GroupBySQLExpression {
    public static func buildExpression<T>(
        _ expression: T
    ) -> Component where T: GroupBySQLExpression {
        [expression]
    }
}
