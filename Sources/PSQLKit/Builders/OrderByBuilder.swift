// OrderByBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

extension EmptyExpression: OrderBySQLExpression {
    public var orderBySqlExpression: some SQLExpression {
        _Empty()
    }

    public var orderByIsNull: Bool { true }
}

extension _ConditionalContent: OrderBySQLExpression where T: OrderBySQLExpression, U: OrderBySQLExpression {
    public var orderBySqlExpression: some SQLExpression {
        _OrderBy(content: self)
    }

    struct _OrderBy: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.orderBySqlExpression.serialize(to: &serializer)
            case let .right(u): u.orderBySqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum OrderByBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: OrderBySQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: OrderBySQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> QueryTuple< repeat each Content> where repeat each Content: OrderBySQLExpression {
        .init(repeat each content)
    }
}

extension OrderByBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: OrderBySQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: OrderBySQLExpression, Right: OrderBySQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: OrderBySQLExpression, Right: OrderBySQLExpression {
        .right(content)
    }
}
