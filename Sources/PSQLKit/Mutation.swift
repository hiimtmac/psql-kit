// Mutation.swift
// Copyright © 2022 hiimtmac

import Foundation

public struct Mutation<T, U> where
    T: TypeEquatable,
    U: TypeEquatable,
    T.CompareType == U.CompareType
{
    let column: T
    let value: U
}

extension Mutation: InsertSQLExpression where
    T: MutationSQLExpression,
    U: MutationSQLExpression
{
    public var insertColumnSqlExpression: SQLExpression {
        self.column.mutationSqlExpression
    }

    public var insertValueSqlExpression: SQLExpression {
        self.value.mutationSqlExpression
    }
}

extension Mutation: UpdateSQLExpression where
    T: MutationSQLExpression,
    U: MutationSQLExpression
{
    private struct _Update: SQLExpression {
        let column: T
        let value: U

        func serialize(to serializer: inout SQLSerializer) {
            self.column.mutationSqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            serializer.write("=")
            serializer.writeSpace()
            self.value.mutationSqlExpression.serialize(to: &serializer)
        }
    }

    public var updateSqlExpression: SQLExpression {
        _Update(column: self.column, value: self.value)
    }
}
