// MutationOperations.swift
// Copyright © 2022 hiimtmac

import Foundation

// MARK: - =>

public func => <T, U>(_ column: T, _ value: U) -> Mutation<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLExpression,
    T.CompareType == U.CompareType
{
    Mutation(column: column, value: value)
}
