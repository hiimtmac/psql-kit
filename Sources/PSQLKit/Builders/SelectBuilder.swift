// SelectBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

extension EmptyExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Empty()
    }

    public var selectIsNull: Bool { true }
}

extension _ConditionalContent: SelectSQLExpression where T: SelectSQLExpression, U: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self)
    }

    struct _Select: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.selectSqlExpression.serialize(to: &serializer)
            case let .right(u): u.selectSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum SelectBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: SelectSQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: SelectSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> QueryTuple< repeat each Content> where repeat each Content: SelectSQLExpression {
        .init(repeat each content)
    }
}

extension SelectBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: SelectSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: SelectSQLExpression, Right: SelectSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: SelectSQLExpression, Right: SelectSQLExpression {
        .right(content)
    }
}
