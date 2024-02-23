// FromBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw

extension EmptyExpression: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression {
        _From()
    }
    
    public var fromIsNull: Bool { true }
    
    private struct _From: SQLExpression {
        func serialize(to serializer: inout SQLSerializer) {
            fatalError("Should not be serialized")
        }
    }
}

public struct FromTouple<each T: FromSQLExpression>: FromSQLExpression {
    let content: (repeat each T)
    
    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
    
    public var fromSqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
}

extension _ConditionalContent: FromSQLExpression where T: FromSQLExpression, U: FromSQLExpression {
    
    public var fromSqlExpression: some SQLExpression {
        _From(content: self)
    }
    
    struct _From: SQLExpression {
        let content: _ConditionalContent<T, U>
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .left(let t): t.fromSqlExpression.serialize(to: &serializer)
            case .right(let u): u.fromSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
public enum FromBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: FromSQLExpression {
        content
    }

    public static func buildBlock() -> EmptyExpression {
        EmptyExpression()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: FromSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> FromTouple<repeat each Content> where repeat each Content: FromSQLExpression {
        .init(repeat each content)
    }
}

extension FromBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: FromSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: FromSQLExpression, Right: FromSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: FromSQLExpression, Right: FromSQLExpression {
        .right(content)
    }
}
