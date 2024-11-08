// PSQLRange.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct PSQLRange<T, U>: Sendable where
    T: TypeEquatable & Sendable,
    U: TypeEquatable & Sendable,
    T.CompareType == U.CompareType
{
    let lower: T
    let upper: U

    public init(from: T, to: U) {
        self.lower = from
        self.upper = to
    }
}

extension PSQLRange: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension PSQLRange: CompareSQLExpression where
    T: CompareSQLExpression,
    U: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(lower: self.lower, upper: self.upper)
    }

    struct _Compare: SQLExpression {
        let lower: T
        let upper: U

        func serialize(to serializer: inout SQLSerializer) {
            self.lower.compareSqlExpression.serialize(to: &serializer)
            serializer.writeSpaced("AND")
            self.upper.compareSqlExpression.serialize(to: &serializer)
        }
    }
}
