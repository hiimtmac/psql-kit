// UnionBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw

struct UnionTouple<each T: UnionSQLExpression>: UnionSQLExpression {
    let content: (repeat each T)
    
    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
    
    var unionSqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(" UNION "))
    }
}

extension _ConditionalContent: UnionSQLExpression where T: UnionSQLExpression, U: UnionSQLExpression {
    
    var unionSqlExpression: some SQLExpression {
        _Union(content: self)
    }
    
    struct _Union: SQLExpression {
        let content: _ConditionalContent<T, U>
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .left(let t): t.unionSqlExpression.serialize(to: &serializer)
            case .right(let u): u.unionSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
enum UnionBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: UnionSQLExpression {
        content
    }

//    public static func buildBlock() -> EmptyView {
//        EmptyView()
//    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: UnionSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> UnionTouple<repeat each Content> where repeat each Content: UnionSQLExpression {
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

