import Foundation
import SQLKit

infix operator ><: LogicalConjunctionPrecedence
infix operator <>: LogicalConjunctionPrecedence

public func ==<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .equal, rhs: rhs)
}

public func !=<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notEqual, rhs: rhs)
}

public func <<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .lessThan, rhs: rhs)
}

public func <=<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .lessThanOrEqual, rhs: rhs)
}

public func ><T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .greaterThan, rhs: rhs)
}

public func >=<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .greaterThanOrEqual, rhs: rhs)
}

public func ||<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U>
{
    CompareExpression(lhs: lhs, operator: .or, rhs: rhs)
}

public func ><<T, U>(_ lhs: T, _ rhs: [U])
-> CompareExpression<T, [U]> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .in, rhs: rhs)
}

public func ><<T, U>(_ lhs: T, _ rhs: ClosedRange<U>)
-> CompareExpression<T, ClosedRange<U>> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .between, rhs: rhs)
}

public func <><T, U>(_ lhs: T, _ rhs: [U])
-> CompareExpression<T, [U]> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notIn, rhs: rhs)
}

public func <><T, U>(_ lhs: T, _ rhs: ClosedRange<U>)
-> CompareExpression<T, ClosedRange<U>> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notBetween, rhs: rhs)
}
