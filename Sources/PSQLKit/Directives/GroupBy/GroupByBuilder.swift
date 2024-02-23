// GroupByBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

struct GroupByTouple<each T: GroupBySQLExpression>: GroupBySQLExpression {
    let content: (repeat each T)
    
    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
    
    var groupByIsNull: Bool {
        groupBySqlExpression.expressions.isEmpty
    }
    
    var groupBySqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
}

extension _ConditionalContent: GroupBySQLExpression where T: GroupBySQLExpression, U: GroupBySQLExpression {
    
    var groupBySqlExpression: some SQLExpression {
        _GroupBY(content: self)
    }
    
    struct _GroupBY: SQLExpression {
        let content: _ConditionalContent<T, U>
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .left(let t): t.groupBySqlExpression.serialize(to: &serializer)
            case .right(let u): u.groupBySqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
enum GroupByBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: GroupBySQLExpression {
        content
    }

//    public static func buildBlock() -> EmptyView {
//        EmptyView()
//    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: GroupBySQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> GroupByTouple<repeat each Content> where repeat each Content: GroupBySQLExpression {
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
