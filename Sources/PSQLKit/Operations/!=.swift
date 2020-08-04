import Foundation

/// !=
func !=<T: Comparing, U: Comparing>(lhs: T, rhs: U) -> PSQLCompareExpression {
    .init(lhs: lhs, instruction: "!=", rhs: rhs)
}
