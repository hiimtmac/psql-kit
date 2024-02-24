// InsertBuilder.swift
// Copyright (c) 2024 hiimtmac inc.

import protocol SQLKit.SQLExpression
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw
import struct SQLKit.SQLSerializer

extension EmptyExpression: InsertSQLExpression {
    public var insertColumnSqlExpression: some SQLExpression {
        _Insert()
    }

    public var insertValueSqlExpression: some SQLExpression {
        _Insert()
    }

    public var insertIsNull: Bool { true }

    private struct _Insert: SQLExpression {
        func serialize(to serializer: inout SQLSerializer) {
            fatalError("Should not be serialized")
        }
    }
}

public struct InsertTouple<each T: InsertSQLExpression>: InsertSQLExpression {
    let content: (repeat each T)

    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }

    // typing this `some SQLExpression` causes "SwiftEmitModule failed with nonzero exit code"
    public var insertColumnSqlExpression: SQLList {
        var collector = Collector()
        _ = (repeat collector.append(column: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }

    // typing this `some SQLExpression` causes "SwiftEmitModule failed with nonzero exit code"
    public var insertValueSqlExpression: SQLList {
        var collector = Collector()
        _ = (repeat collector.append(value: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
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
    ) -> InsertTouple< repeat each Content> where repeat each Content: InsertSQLExpression {
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
