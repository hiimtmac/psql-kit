// QueryBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

struct QueryTouple<each T: QuerySQLExpression>: QuerySQLExpression {
    let content: (repeat each T)
    
    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
    
    var querySqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(" "))
    }
}

extension _ConditionalContent: QuerySQLExpression where T: QuerySQLExpression, U: QuerySQLExpression {
    
    var querySqlExpression: some SQLExpression {
        _Query(content: self)
    }
    
    struct _Query: SQLExpression {
        let content: _ConditionalContent<T, U>
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .left(let t): t.querySqlExpression.serialize(to: &serializer)
            case .right(let u): u.querySqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
enum QueryBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: QuerySQLExpression {
        content
    }

//    public static func buildBlock() -> EmptyView {
//        EmptyView()
//    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: QuerySQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> QueryTouple<repeat each Content> where repeat each Content: QuerySQLExpression {
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
