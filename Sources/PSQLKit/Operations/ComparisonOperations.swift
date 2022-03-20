// ComparisonOperations.swift
// Copyright © 2022 hiimtmac

import FluentKit
import Foundation
import SQLKit

public typealias PSQLEquatable = PSQLExpression & Equatable
public typealias PSQLComparable = PSQLExpression & Comparable

// MARK: - ==

/// lhs = rhs
public func == <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLEquatable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .equal, rhs: rhs)
}

// MARK: - ===

/// lhs IS rhs
public func === <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLEquatable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .is, rhs: rhs)
}

// MARK: - !=

/// lhs != rhs
public func != <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLEquatable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notEqual, rhs: rhs)
}

// MARK: - !==

/// lhs IS NOT rhs
public func !== <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLEquatable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .isNot, rhs: rhs)
}

// MARK: - <

/// lhs < rhs
public func < <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLComparable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .lessThan, rhs: rhs)
}

// MARK: - <=

/// lhs <= rhs
public func <= <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLComparable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .lessThanOrEqual, rhs: rhs)
}

// MARK: - >

/// lhs > rhs
public func > <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLComparable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .greaterThan, rhs: rhs)
}

// MARK: - >=

/// lhs >= rhs
public func >= <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLComparable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .greaterThanOrEqual, rhs: rhs)
}

// MARK: - OR

/// lhs OR rhs
public func || <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> {
    CompareExpression(lhs: lhs, operator: .or, rhs: rhs)
}

// MARK: - AND

/// lhs OR rhs
public func && <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> {
    CompareExpression(lhs: lhs, operator: .and, rhs: rhs)
}

// MARK: - Range

/// lhs IN rhs
public func ... <T, U>(_ lhs: T, _ rhs: U) -> PSQLRange<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType == U.CompareType
{
    PSQLRange(from: lhs, to: rhs)
}

// MARK: - IN

/// lhs IN rhs
public func >< <T, U>(_ lhs: T, _ rhs: [U]) -> CompareExpression<T, [U]> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .in, rhs: rhs)
}

// MARK: - BETWEEN

/// lhs BETWEEN rhs
public func >< <T, U, V>(_ lhs: T, _ rhs: PSQLRange<U, V>) -> CompareExpression<T, PSQLRange<U, V>> where
    T: TypeEquatable,
    U: TypeEquatable,
    V: TypeEquatable,
    T.CompareType == U.CompareType,
    U.CompareType == V.CompareType
{
    CompareExpression(lhs: lhs, operator: .between, rhs: rhs)
}

// MARK: - NOT IN

/// lhs NOT IN rhs
public func <> <T, U>(_ lhs: T, _ rhs: [U]) -> CompareExpression<T, [U]> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notIn, rhs: rhs)
}

// MARK: - NOT BETWEEN

/// lhs NOT BETWEEN rhs
public func <> <T, U, V>(_ lhs: T, _ rhs: PSQLRange<U, V>) -> CompareExpression<T, PSQLRange<U, V>> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType == U.CompareType,
    U.CompareType == V.CompareType
{
    CompareExpression(lhs: lhs, operator: .notBetween, rhs: rhs)
}

// MARK: - LIKE

/// lhs LIKE rhs
public func ~~ <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .like, rhs: rhs)
}

// MARK: - NOT LIKE

/// lhs NOT LIKE rhs
public func !~~ <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notLike, rhs: rhs)
}

// MARK: - ILIKE

/// lhs ILIKE rhs
public func ~~* <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .iLike, rhs: rhs)
}

// MARK: - NOT ILIKE

/// lhs NOT ILIKE rhs
public func !~~* <T, U>(_ lhs: T, _ rhs: U) -> CompareExpression<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType == U.CompareType
{
    CompareExpression(lhs: lhs, operator: .notILike, rhs: rhs)
}
