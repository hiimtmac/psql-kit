// ExpressionAlias.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct ExpressionAlias<Expression>: Sendable where Expression: Sendable {
    let expression: Expression
    let alias: String
}

extension ExpressionAlias: TypeEquatable where Expression: TypeEquatable {
    public typealias CompareType = Expression.CompareType
}

extension ExpressionAlias: SelectSQLExpression where
    Expression: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(expression: self.expression, alias: self.alias)
    }

    struct _Select: SQLExpression {
        let expression: Expression
        let alias: String

        func serialize(to serializer: inout SQLSerializer) {
            self.expression.selectSqlExpression.serialize(to: &serializer)

            serializer.writeSpaced("AS")

            serializer.writeIdentifier(self.alias)
        }
    }
}

extension ExpressionAlias: FromSQLExpression where
    Expression: FromSQLExpression
{
    public var fromSqlExpression: some SQLExpression {
        _From(expression: self.expression, alias: self.alias)
    }

    struct _From: SQLExpression {
        let expression: Expression
        let alias: String

        func serialize(to serializer: inout SQLSerializer) {
            self.expression.fromSqlExpression.serialize(to: &serializer)

            serializer.writeSpaced("AS")

            serializer.writeIdentifier(self.alias)
        }
    }
}
