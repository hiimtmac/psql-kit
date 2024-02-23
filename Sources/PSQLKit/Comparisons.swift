// Comparisons.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct CompareOperator: SQLExpression {
    let value: String

    public init(_ value: String) {
        self.value = value
    }

    public static let equal = CompareOperator("=")
    public static let notEqual = CompareOperator("!=")
    public static let `in` = CompareOperator("IN")
    public static let notIn = CompareOperator("NOT IN")
    public static let lessThan = CompareOperator("<")
    public static let lessThanOrEqual = CompareOperator("<=")
    public static let greaterThan = CompareOperator(">")
    public static let greaterThanOrEqual = CompareOperator(">=")
    public static let between = CompareOperator("BETWEEN")
    public static let notBetween = CompareOperator("NOT BETWEEN")
    public static let and = CompareOperator("AND")
    public static let or = CompareOperator("OR")
    public static let like = CompareOperator("LIKE")
    public static let notLike = CompareOperator("NOT LIKE")
    public static let iLike = CompareOperator("ILIKE")
    public static let notILike = CompareOperator("NOT ILIKE")
    public static let `is` = CompareOperator("IS")
    public static let isNot = CompareOperator("IS NOT")

    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write(self.value)
    }
}

public struct CompareExpression<T, U> where
    T: CompareSQLExpression,
    U: CompareSQLExpression
{
    let lhs: T
    let `operator`: CompareOperator
    let rhs: U

    public init(lhs: T, operator: CompareOperator, rhs: U) {
        self.lhs = lhs
        self.operator = `operator`
        self.rhs = rhs
    }
}

extension CompareExpression: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression {
        _Compare(lhs: self.lhs, operator: self.operator, rhs: self.rhs)
    }

    private struct _Compare: SQLExpression {
        let lhs: T
        let `operator`: CompareOperator
        let rhs: U

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("(")
            self.lhs.compareSqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            self.operator.serialize(to: &serializer)
            serializer.writeSpace()
            self.rhs.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension CompareExpression: WhereSQLExpression {
    public var whereSqlExpression: some SQLExpression {
        _Compare(lhs: self.lhs, operator: self.operator, rhs: self.rhs)
    }
}

extension CompareExpression: HavingSQLExpression {
    public var havingSqlExpression: some SQLExpression {
        _Compare(lhs: self.lhs, operator: self.operator, rhs: self.rhs)
    }
}

extension CompareExpression: JoinSQLExpression {
    public var joinSqlExpression: some SQLExpression {
        _Compare(lhs: self.lhs, operator: self.operator, rhs: self.rhs)
    }
}
