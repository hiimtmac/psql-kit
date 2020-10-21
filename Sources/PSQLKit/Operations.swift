import Foundation
import SQLKit

// MARK: - ==
/// lhs = rhs
public func ==<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .equal, rhs: rhs)
}

// MARK: - !=
/// lhs != rhs
public func !=<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notEqual, rhs: rhs)
}

// MARK: - <
/// lhs < rhs
public func <<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .lessThan, rhs: rhs)
}

// MARK: - <=
/// lhs <= rhs
public func <=<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .lessThanOrEqual, rhs: rhs)
}

// MARK: - >
/// lhs > rhs
public func ><T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .greaterThan, rhs: rhs)
}

// MARK: - >=
/// lhs >= rhs
public func >=<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .greaterThanOrEqual, rhs: rhs)
}

// MARK: - OR
/// lhs OR rhs
public func ||<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U>
{
    CompareExpression(lhs: lhs, operator: .or, rhs: rhs)
}

postfix operator .*
infix operator ...: LogicalConjunctionPrecedence
infix operator ><: ComparisonPrecedence
infix operator <>: ComparisonPrecedence
infix operator ~~: ComparisonPrecedence
infix operator !~~: ComparisonPrecedence
infix operator ~~*: ComparisonPrecedence
infix operator !~~*: ComparisonPrecedence

// MARK: - Range
/// lhs IN rhs
public func ...<T>(_ lhs: T, _ rhs: T) -> PSQLRange<T> where T: TypeEquatable
{
    PSQLRange(from: lhs, to: rhs)
}

// MARK: - IN
/// lhs IN rhs
public func ><<T, U>(_ lhs: T, _ rhs: [U])
-> CompareExpression<T, [U]> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .in, rhs: rhs)
}

// MARK: - BETWEEN
/// lhs BETWEEN rhs
public func ><<T, U>(_ lhs: T, _ rhs: PSQLRange<U>)
-> CompareExpression<T, PSQLRange<U>> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .between, rhs: rhs)
}

// MARK: - NOT IN
/// lhs NOT IN rhs
public func <><T, U>(_ lhs: T, _ rhs: [U])
-> CompareExpression<T, [U]> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notIn, rhs: rhs)
}

// MARK: - NOT BETWEEN
/// lhs NOT BETWEEN rhs
public func <><T, U>(_ lhs: T, _ rhs: PSQLRange<U>)
-> CompareExpression<T, PSQLRange<U>> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notBetween, rhs: rhs)
}

// MARK: - LIKE
/// lhs LIKE rhs
public func ~~<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .like, rhs: rhs)
}

// MARK: - NOT LIKE
/// lhs NOT LIKE rhs
public func !~~<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notLike, rhs: rhs)
}

// MARK: - ILIKE
/// lhs ILIKE rhs
public func ~~*<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .iLike, rhs: rhs)
}

// MARK: - NOT ILIKE
/// lhs NOT ILIKE rhs
public func !~~*<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notILike, rhs: rhs)
}
