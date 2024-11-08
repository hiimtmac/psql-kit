// GroupByBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

extension EmptyExpression: GroupBySQLExpression {
    public var groupBySqlExpression: some SQLExpression {
        _Empty()
    }

    public var groupByIsNull: Bool { true }
}

extension _ConditionalContent: GroupBySQLExpression where T: GroupBySQLExpression, U: GroupBySQLExpression {
    public var groupBySqlExpression: some SQLExpression {
        _GroupBY(content: self)
    }

    struct _GroupBY: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.groupBySqlExpression.serialize(to: &serializer)
            case let .right(u): u.groupBySqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum GroupByBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: GroupBySQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: GroupBySQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> QueryTuple< repeat each Content> where repeat each Content: GroupBySQLExpression {
        .init(repeat each content)
    }
}

extension GroupByBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: GroupBySQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: GroupBySQLExpression, Right: GroupBySQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: GroupBySQLExpression, Right: GroupBySQLExpression {
        .right(content)
    }
}
