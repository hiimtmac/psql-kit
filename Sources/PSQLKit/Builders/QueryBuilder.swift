// QueryBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import protocol SQLKit.SQLExpression
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw
import struct SQLKit.SQLSerializer

extension EmptyExpression: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression {
        _Query()
    }

    public var queryIsNull: Bool { true }

    private struct _Query: SQLExpression {
        func serialize(to serializer: inout SQLSerializer) {
            fatalError("Should not be serialized")
        }
    }
}

public struct QueryTouple<each T: QuerySQLExpression>: QuerySQLExpression {
    let content: (repeat each T)

    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }

    public var querySqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(" "))
    }
}

extension _ConditionalContent: QuerySQLExpression where T: QuerySQLExpression, U: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression {
        _Query(content: self)
    }

    struct _Query: SQLExpression {
        let content: _ConditionalContent<T, U>

        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case let .left(t): t.querySqlExpression.serialize(to: &serializer)
            case let .right(u): u.querySqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum QueryBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: QuerySQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: QuerySQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> QueryTouple< repeat each Content> where repeat each Content: QuerySQLExpression {
        .init(repeat each content)
    }
}

extension QueryBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: QuerySQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: QuerySQLExpression, Right: QuerySQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: QuerySQLExpression, Right: QuerySQLExpression {
        .right(content)
    }
}
