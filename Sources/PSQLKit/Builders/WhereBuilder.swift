// WhereBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

extension EmptyExpression: WhereSQLExpression {
    public var whereSqlExpression: some SQLExpression {
        _Empty()
    }

    public var whereIsNull: Bool { true }
}

extension _ConditionalContent: WhereSQLExpression where T: WhereSQLExpression, U: WhereSQLExpression {
    public var whereSqlExpression: some SQLExpression {
        _Where(content: self)
    }

    struct _Where: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.whereSqlExpression.serialize(to: &serializer)
            case let .right(u): u.whereSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum WhereBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: WhereSQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: WhereSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> QueryTuple< repeat each Content> where repeat each Content: WhereSQLExpression {
        .init(repeat each content)
    }
}

extension WhereBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: WhereSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: WhereSQLExpression, Right: WhereSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: WhereSQLExpression, Right: WhereSQLExpression {
        .right(content)
    }
}
