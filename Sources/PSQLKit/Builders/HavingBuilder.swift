// HavingBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

extension EmptyExpression: HavingSQLExpression {
    public var havingSqlExpression: some SQLExpression {
        _Empty()
    }

    public var havingIsNull: Bool { true }
}

extension _ConditionalContent: HavingSQLExpression where T: HavingSQLExpression, U: HavingSQLExpression {
    public var havingSqlExpression: some SQLExpression {
        _Having(content: self)
    }

    struct _Having: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.havingSqlExpression.serialize(to: &serializer)
            case let .right(u): u.havingSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum HavingBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: HavingSQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: HavingSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> QueryTuple< repeat each Content> where repeat each Content: HavingSQLExpression {
        .init(repeat each content)
    }
}

extension HavingBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: HavingSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: HavingSQLExpression, Right: HavingSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: HavingSQLExpression, Right: HavingSQLExpression {
        .right(content)
    }
}
