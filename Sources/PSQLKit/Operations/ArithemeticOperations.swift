// ArithemeticOperations.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation

// MARK: - +

/// lhs + rhs
public func + <T, U>(_ lhs: T, _ rhs: U) -> ArithmeticExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLExpression,
    T.CompareType == U.CompareType
{
    ArithmeticExpression(lhs: lhs, operator: .addition, rhs: rhs)
}

// MARK: - -

/// lhs - rhs
public func - <T, U>(_ lhs: T, _ rhs: U) -> ArithmeticExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLExpression,
    T.CompareType == U.CompareType
{
    ArithmeticExpression(lhs: lhs, operator: .subtraction, rhs: rhs)
}

// MARK: - *

/// lhs * rhs
public func * <T, U>(_ lhs: T, _ rhs: U) -> ArithmeticExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLExpression,
    T.CompareType == U.CompareType
{
    ArithmeticExpression(lhs: lhs, operator: .multiplication, rhs: rhs)
}

// MARK: - /

/// lhs / rhs
public func / <T, U>(_ lhs: T, _ rhs: U) -> ArithmeticExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLExpression,
    T.CompareType == U.CompareType
{
    ArithmeticExpression(lhs: lhs, operator: .division, rhs: rhs)
}
