// WithBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import protocol SQLKit.SQLExpression
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw
import struct SQLKit.SQLSerializer

extension EmptyExpression: WithSQLExpression {
    public var withSqlExpression: some SQLExpression {
        _With()
    }

    public var withIsNull: Bool { true }

    private struct _With: SQLExpression {
        func serialize(to serializer: inout SQLSerializer) {
            fatalError("Should not be serialized")
        }
    }
}

public struct WithTouple<each T: WithSQLExpression>: WithSQLExpression {
    let content: (repeat each T)

    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }

    // typing this `some SQLExpression` causes "SwiftEmitModule failed with nonzero exit code"
    public var withSqlExpression: SQLList {
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
}

extension _ConditionalContent: WithSQLExpression where T: WithSQLExpression, U: WithSQLExpression {
    public var withSqlExpression: some SQLExpression {
        _With(content: self)
    }

    struct _With: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.withSqlExpression.serialize(to: &serializer)
            case let .right(u): u.withSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum WithBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: WithSQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: WithSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> WithTouple< repeat each Content> where repeat each Content: WithSQLExpression {
        .init(repeat each content)
    }
}

extension WithBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: WithSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: WithSQLExpression, Right: WithSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: WithSQLExpression, Right: WithSQLExpression {
        .right(content)
    }
}
