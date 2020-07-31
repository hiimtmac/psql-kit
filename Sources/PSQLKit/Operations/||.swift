import Foundation

/// OR
func ||(lhs: PSQLCompareExpression, rhs: PSQLCompareExpression) -> PSQLCompareExpression {
    .init(lhs: lhs, instruction: " OR ", rhs: rhs)
}
