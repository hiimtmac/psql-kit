// SelectBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import protocol SQLKit.SQLExpression
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw
import struct SQLKit.SQLSerializer

extension EmptyExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Select()
    }

    public var selectIsNull: Bool { true }

    private struct _Select: SQLExpression {
        func serialize(to serializer: inout SQLSerializer) {
            fatalError("Should not be serialized")
        }
    }
}

public struct SelectTouple<each T: SelectSQLExpression>: SelectSQLExpression {
    let content: (repeat each T)

    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }

    public var selectSqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
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
    ) -> SelectTouple< repeat each Content> where repeat each Content: SelectSQLExpression {
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
