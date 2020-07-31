import Foundation

infix operator >><<: LogicalConjunctionPrecedence

/// BETWEEN
func >><<<T: TypeComparable, U: TypeComparable & PSQLable>(lhs: PSQLTypedColumnExpression<T>, rhs: (U, U)) -> PSQLCompareExpression where T.T == U.T {
    .init(lhs: lhs, instruction: " BETWEEN ", rhs: PSQLList([rhs.0, rhs.1], separator: PSQLRaw(" AND "), bounds: (PSQLRaw("("), PSQLRaw(")"))))
}
