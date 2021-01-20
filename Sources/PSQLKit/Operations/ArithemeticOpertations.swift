import Foundation
import SQLKit
import FluentKit

// MARK: - +
/// lhs = rhs
public func +<T, U>(_ lhs: T, _ rhs: U) -> ArithmeticExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLExpression,
    T.CompareType == U.CompareType
{
    ArithmeticExpression(lhs: lhs, operator: .addition, rhs: rhs)
}

// MARK: - -
/// lhs IS rhs
public func -<T, U>(_ lhs: T, _ rhs: U) -> ArithmeticExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLExpression,
    T.CompareType == U.CompareType
{
    ArithmeticExpression(lhs: lhs, operator: .subtraction, rhs: rhs)
}

// MARK: - *
/// lhs != rhs
public func *<T, U>(_ lhs: T, _ rhs: U) -> ArithmeticExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLExpression,
    T.CompareType == U.CompareType
{
    ArithmeticExpression(lhs: lhs, operator: .multiplication, rhs: rhs)
}

// MARK: - /
/// lhs IS NOT rhs
public func /<T, U>(_ lhs: T, _ rhs: U) -> ArithmeticExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLExpression,
    T.CompareType == U.CompareType
{
    ArithmeticExpression(lhs: lhs, operator: .division, rhs: rhs)
}
