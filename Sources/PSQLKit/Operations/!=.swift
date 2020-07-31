import Foundation

/// !=
func !=<T>(lhs: PSQLTypedColumnExpression<T>, rhs: PSQLTypedColumnExpression<T>) -> PSQLCompareExpression {
    .init(lhs: lhs, instruction: "!=", rhs: rhs)
}
