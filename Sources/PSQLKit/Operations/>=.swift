import Foundation

/// >=
func >=<T: Comparing, U: Comparing>(lhs: T, rhs: U) -> PSQLCompareExpression where T.T == U.T {
    .init(lhs: lhs, instruction: ">=", rhs: rhs)
}
