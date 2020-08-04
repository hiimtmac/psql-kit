import Foundation

infix operator ><: LogicalConjunctionPrecedence

/// IN
func ><<T: Comparing, U: Comparing>(lhs: T, rhs: [U]) -> PSQLCompareExpression where T.T == U.T {
    .init(lhs: lhs, instruction: " IN ", rhs: PSQLList(rhs.map(\.compare), bounds: (PSQLRaw.openBracket, PSQLRaw.closedBracket)))
}
