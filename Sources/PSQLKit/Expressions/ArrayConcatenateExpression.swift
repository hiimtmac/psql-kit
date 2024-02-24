// ArrayConcatenateExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct ArrayConcatenateExpression<T, U>: AggregateExpression where
    T: PSQLArrayRepresentable & TypeEquatable,
    U: PSQLArrayRepresentable & TypeEquatable,
    T.CompareType == U.CompareType
{
    let one: T
    let two: U

    public init(_ one: T, _ two: U) {
        self.one = one
        self.two = two
    }
}

extension ArrayConcatenateExpression: SelectSQLExpression where
    T: SelectSQLExpression,
    U: SelectSQLExpression,
    T.CompareType: PSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(one: self.one, two: self.two)
    }

    private struct _Select: SQLExpression {
        let one: T
        let two: U

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_CAT")
            serializer.write("(")
            self.one.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.two.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            PostgresDataType.array(T.CompareType.postgresDataType).serialize(to: &serializer)
        }
    }
}

extension ArrayConcatenateExpression: CompareSQLExpression where
    T: CompareSQLExpression,
    U: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(one: self.one, two: self.two)
    }

    private struct _Compare: SQLExpression {
        let one: T
        let two: U

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_CAT")
            serializer.write("(")
            self.one.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.two.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayConcatenateExpression: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = [T.CompareType]
}

extension ArrayConcatenateExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayConcatenateExpression<T, U>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
