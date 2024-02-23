// WithBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw

struct WithTouple<each T: WithSQLExpression>: WithSQLExpression {
    let content: (repeat each T)
    
    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
    
    var withIsNull: Bool {
        withSqlExpression.expressions.isEmpty
    }
    
    var withSqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
}

extension _ConditionalContent: WithSQLExpression where T: WithSQLExpression, U: WithSQLExpression {
    
    var withSqlExpression: some SQLExpression {
        _With(content: self)
    }
    
    struct _With: SQLExpression {
        let content: _ConditionalContent<T, U>
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .left(let t): t.withSqlExpression.serialize(to: &serializer)
            case .right(let u): u.withSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
enum WithBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: WithSQLExpression {
        content
    }

//    public static func buildBlock() -> EmptyView {
//        EmptyView()
//    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: WithSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> WithTouple<repeat each Content> where repeat each Content: WithSQLExpression {
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
