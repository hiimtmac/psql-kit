// UnionBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw
import struct SQLKit.SQLSerializer

extension EmptyExpression: UnionSQLExpression {
    public var unionSqlExpression: some SQLExpression {
        _Union()
    }

    public var unionIsNull: Bool { true }

    private struct _Union: SQLExpression {
        func serialize(to serializer: inout SQLSerializer) {
            fatalError("Should not be serialized")
        }
    }
}

public struct UnionTouple<each T: UnionSQLExpression>: UnionSQLExpression {
    let content: (repeat each T)

    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }

    public var unionSqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(" UNION "))
    }
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
    ) -> UnionTouple< repeat each Content> where repeat each Content: UnionSQLExpression {
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
