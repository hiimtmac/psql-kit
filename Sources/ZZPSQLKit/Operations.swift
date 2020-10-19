import Foundation
import SQLKit

func ==<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .equal, rhs: rhs)
}

func !=<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notEqual, rhs: rhs)
}

func <<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .lessThan, rhs: rhs)
}

func <=<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .lessThanOrEqual, rhs: rhs)
}

func ><T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .greaterThan, rhs: rhs)
}

func >=<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .greaterThanOrEqual, rhs: rhs)
}

func ||<T, U>(_ lhs: T, _ rhs: U)
-> CompareExpression<T, U>
{
    CompareExpression(lhs: lhs, operator: .or, rhs: rhs)
}

infix operator ><: LogicalConjunctionPrecedence
func ><<T, U>(_ lhs: T, _ rhs: [U])
-> CompareExpression<T, [U]> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .in, rhs: rhs)
}

func ><<T, U>(_ lhs: T, _ rhs: ClosedRange<U>)
-> CompareExpression<T, ClosedRange<U>> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .between, rhs: rhs)
}

infix operator <>: LogicalConjunctionPrecedence
func <><T, U>(_ lhs: T, _ rhs: [U])
-> CompareExpression<T, [U]> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notIn, rhs: rhs)
}

func <><T, U>(_ lhs: T, _ rhs: ClosedRange<U>)
-> CompareExpression<T, ClosedRange<U>> where T: TypeEquatable, U: TypeEquatable, T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notBetween, rhs: rhs)
}
