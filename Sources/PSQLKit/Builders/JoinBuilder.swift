// JoinBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import protocol SQLKit.SQLExpression
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw
import struct SQLKit.SQLSerializer

extension EmptyExpression: JoinSQLExpression {
    public var joinSqlExpression: some SQLExpression {
        _Join()
    }

    public var joinIsNull: Bool { true }

    private struct _Join: SQLExpression {
        func serialize(to serializer: inout SQLSerializer) {
            fatalError("Should not be serialized")
        }
    }
}

public struct JoinTouple<each T: JoinSQLExpression>: JoinSQLExpression {
    let content: (repeat each T)

    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }

    // typing this `some SQLExpression` causes "SwiftEmitModule failed with nonzero exit code"
    public var joinSqlExpression: SQLList {
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(" AND "))
    }
}

extension _ConditionalContent: JoinSQLExpression where T: JoinSQLExpression, U: JoinSQLExpression {
    public var joinSqlExpression: some SQLExpression {
        _Join(content: self)
    }

    struct _Join: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.joinSqlExpression.serialize(to: &serializer)
            case let .right(u): u.joinSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum JoinBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: JoinSQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: JoinSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> JoinTouple< repeat each Content> where repeat each Content: JoinSQLExpression {
        .init(repeat each content)
    }
}

extension JoinBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: JoinSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: JoinSQLExpression, Right: JoinSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: JoinSQLExpression, Right: JoinSQLExpression {
        .right(content)
    }
}
