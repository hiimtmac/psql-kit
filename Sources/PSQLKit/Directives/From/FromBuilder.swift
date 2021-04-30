import Foundation

typealias FromBuilder = Builder<FromSQLExpression>

extension Builder where T == FromSQLExpression {
    public static func buildExpression<T>(
        _ expression: T
    ) -> Component where T: FromSQLExpression {
        [expression]
    }
}
