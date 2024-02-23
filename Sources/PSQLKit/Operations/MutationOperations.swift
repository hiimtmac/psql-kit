// MutationOperations.swift
// Copyright (c) 2024 hiimtmac inc.

// MARK: - =>

public func => <T, U>(_ column: T, _ value: U) -> Mutation<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType: PSQLExpression,
    T.CompareType == U.CompareType
{
    Mutation(column: column, value: value)
}
