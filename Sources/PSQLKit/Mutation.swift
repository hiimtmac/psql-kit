// Mutation.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct Mutation<T, U>: Sendable where
    T: TypeEquatable & Sendable,
    U: TypeEquatable & Sendable,
    T.CompareType == U.CompareType
{
    let column: T
    let value: U
}

extension Mutation: InsertSQLExpression where
    T: MutationSQLExpression,
    U: MutationSQLExpression
{
    public var insertColumnSqlExpression: some SQLExpression {
        self.column.mutationSqlExpression
    }

    public var insertValueSqlExpression: some SQLExpression {
        self.value.mutationSqlExpression
    }
}

extension Mutation: UpdateSQLExpression where
    T: MutationSQLExpression,
    U: MutationSQLExpression
{
    struct _Update: SQLExpression {
        let column: T
        let value: U

        func serialize(to serializer: inout SQLSerializer) {
            self.column.mutationSqlExpression.serialize(to: &serializer)
            serializer.writeSpaced("=")
            self.value.mutationSqlExpression.serialize(to: &serializer)
        }
    }

    public var updateSqlExpression: some SQLExpression {
        _Update(column: self.column, value: self.value)
    }
}
