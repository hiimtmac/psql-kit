// UpdateBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import protocol SQLKit.SQLExpression
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw
import struct SQLKit.SQLSerializer

extension EmptyExpression: UpdateSQLExpression {
    public var updateSqlExpression: some SQLExpression {
        _Empty()
    }

    public var updateIsNull: Bool { true }
}

public struct UpdateTouple<each T>: UpdateSQLExpression where repeat each T: UpdateSQLExpression {
    let content: (repeat each T)

    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }

    public var updateSqlExpression: some SQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
}

extension _ConditionalContent: UpdateSQLExpression where T: UpdateSQLExpression, U: UpdateSQLExpression {
    public var updateSqlExpression: some SQLExpression {
        _Update(content: self)
    }

    struct _Update: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.updateSqlExpression.serialize(to: &serializer)
            case let .right(u): u.updateSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum UpdateBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: UpdateSQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: UpdateSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> UpdateTouple< repeat each Content> where repeat each Content: UpdateSQLExpression {
        .init(repeat each content)
    }
}

extension UpdateBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: UpdateSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: UpdateSQLExpression, Right: UpdateSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: UpdateSQLExpression, Right: UpdateSQLExpression {
        .right(content)
    }
}
