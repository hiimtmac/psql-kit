// UnionBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

extension EmptyExpression: UnionSQLExpression {
    public var unionSqlExpression: some SQLExpression {
        _Empty()
    }

    public var unionIsNull: Bool { true }
}

extension _ConditionalContent: UnionSQLExpression where T: UnionSQLExpression, U: UnionSQLExpression {
    public var unionSqlExpression: some SQLExpression {
        _Union(content: self)
    }

    struct _Union: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.unionSqlExpression.serialize(to: &serializer)
            case let .right(u): u.unionSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum UnionBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: UnionSQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: UnionSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> QueryTuple< repeat each Content> where repeat each Content: UnionSQLExpression {
        .init(repeat each content)
    }
}

extension UnionBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: UnionSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: UnionSQLExpression, Right: UnionSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: UnionSQLExpression, Right: UnionSQLExpression {
        .right(content)
    }
}
