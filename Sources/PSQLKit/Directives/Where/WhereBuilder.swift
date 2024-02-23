// WhereBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw

struct WhereTouple<each T: WhereSQLExpression>: WhereSQLExpression {
    let content: (repeat each T)
    
    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
    
    var whereIsNull: Bool {
        whereSqlExpression.expressions.isEmpty
    }
    
    var whereSqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(" AND "))
    }
}

extension _ConditionalContent: WhereSQLExpression where T: WhereSQLExpression, U: WhereSQLExpression {
    
    var whereSqlExpression: some SQLExpression {
        _Where(content: self)
    }
    
    struct _Where: SQLExpression {
        let content: _ConditionalContent<T, U>
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .left(let t): t.whereSqlExpression.serialize(to: &serializer)
            case .right(let u): u.whereSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
enum WhereBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: WhereSQLExpression {
        content
    }

//    public static func buildBlock() -> EmptyView {
//        EmptyView()
//    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: WhereSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> WhereTouple<repeat each Content> where repeat each Content: WhereSQLExpression {
        .init(repeat each content)
    }
}

extension WhereBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: WhereSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: WhereSQLExpression, Right: WhereSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: WhereSQLExpression, Right: WhereSQLExpression {
        .right(content)
    }
}
