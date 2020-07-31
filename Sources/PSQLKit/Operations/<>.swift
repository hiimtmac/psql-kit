import Foundation

infix operator <>: LogicalConjunctionPrecedence

/// NOT IN
func <><T: TypeComparable, U: TypeComparable & PSQLable>(lhs: PSQLTypedColumnExpression<T>, rhs: [U]) -> PSQLCompareExpression where T.T == U.T {
    .init(lhs: lhs, instruction: " NOT IN ", rhs: PSQLList(rhs, bounds: (PSQLRaw("("), PSQLRaw(")"))))
}
