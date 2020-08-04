import Foundation

infix operator <>: LogicalConjunctionPrecedence

/// NOT IN
func <><T: Comparing, U: Comparing>(lhs: T, rhs: [U]) -> PSQLCompareExpression where T.T == U.T {
    .init(lhs: lhs, instruction: " NOT IN ", rhs: PSQLList(rhs.map(\.compare), bounds: (PSQLRaw.openBracket, PSQLRaw.closedBracket)))
}
