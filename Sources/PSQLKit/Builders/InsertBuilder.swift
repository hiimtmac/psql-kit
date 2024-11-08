// InsertBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

extension EmptyExpression: InsertSQLExpression {
    public var insertColumnSqlExpression: some SQLExpression {
        _Empty()
    }

    public var insertValueSqlExpression: some SQLExpression {
        _Empty()
    }

    public var insertIsNull: Bool { true }
}

extension _ConditionalContent: InsertSQLExpression where T: InsertSQLExpression, U: InsertSQLExpression {
    public var insertColumnSqlExpression: some SQLExpression {
        _InsertColumn(content: self)
    }

    struct _InsertColumn: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.insertColumnSqlExpression.serialize(to: &serializer)
            case let .right(u): u.insertColumnSqlExpression.serialize(to: &serializer)
            }
        }
    }

    public var insertValueSqlExpression: some SQLExpression {
        _InsertValue(content: self)
    }

    struct _InsertValue: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.insertValueSqlExpression.serialize(to: &serializer)
            case let .right(u): u.insertValueSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum InsertBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: InsertSQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: InsertSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> QueryTuple< repeat each Content> where repeat each Content: InsertSQLExpression {
        .init(repeat each content)
    }
}

extension InsertBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: InsertSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: InsertSQLExpression, Right: InsertSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: InsertSQLExpression, Right: InsertSQLExpression {
        .right(content)
    }
}
