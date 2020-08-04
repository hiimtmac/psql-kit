import Foundation

infix operator >><<: LogicalConjunctionPrecedence

/// BETWEEN
func >><<<T: Comparing, U: Comparing>(lhs: T, rhs: (U, U)) -> PSQLCompareExpression where T.T == U.T {
    .init(lhs: lhs, instruction: " BETWEEN ", rhs: PSQLGroupExpression([rhs.0, rhs.1].map(\.compare), separator: PSQLRaw.and))
}
