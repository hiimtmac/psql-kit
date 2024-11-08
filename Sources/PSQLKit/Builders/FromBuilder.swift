// FromBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

extension EmptyExpression: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression {
        _Empty()
    }

    public var fromIsNull: Bool { true }
}

extension _ConditionalContent: FromSQLExpression where T: FromSQLExpression, U: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression {
        _From(content: self)
    }

    struct _From: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.fromSqlExpression.serialize(to: &serializer)
            case let .right(u): u.fromSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum FromBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: FromSQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: FromSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> QueryTuple< repeat each Content> where repeat each Content: FromSQLExpression {
        .init(repeat each content)
    }
}

extension FromBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: FromSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: FromSQLExpression, Right: FromSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: FromSQLExpression, Right: FromSQLExpression {
        .right(content)
    }
}
