// GroupByBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import protocol SQLKit.SQLExpression
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw
import struct SQLKit.SQLSerializer

extension EmptyExpression: GroupBySQLExpression {
    public var groupBySqlExpression: some SQLExpression {
        _GroupBy()
    }

    public var groupByIsNull: Bool { true }

    private struct _GroupBy: SQLExpression {
        func serialize(to serializer: inout SQLSerializer) {
            fatalError("Should not be serialized")
        }
    }
}

public struct GroupByTouple<each T: GroupBySQLExpression>: GroupBySQLExpression {
    let content: (repeat each T)

    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }

    public var groupBySqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
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
    ) -> GroupByTouple< repeat each Content> where repeat each Content: GroupBySQLExpression {
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
