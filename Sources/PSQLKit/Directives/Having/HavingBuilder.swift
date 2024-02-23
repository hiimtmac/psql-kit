// HavingBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

struct HavingTouple<each T: HavingSQLExpression>: HavingSQLExpression {
    let content: (repeat each T)
    
    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
    
    var havingIsNull: Bool {
        havingSqlExpression.expressions.isEmpty
    }
    
    var havingSqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(" AND "))
    }
}

extension _ConditionalContent: HavingSQLExpression where T: HavingSQLExpression, U: HavingSQLExpression {
    
    var havingSqlExpression: some SQLExpression {
        _Having(content: self)
    }
    
    struct _Having: SQLExpression {
        let content: _ConditionalContent<T, U>
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .left(let t): t.havingSqlExpression.serialize(to: &serializer)
            case .right(let u): u.havingSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
enum HavingBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: HavingSQLExpression {
        content
    }

//    public static func buildBlock() -> EmptyView {
//        EmptyView()
//    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: HavingSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> HavingTouple<repeat each Content> where repeat each Content: HavingSQLExpression {
        .init(repeat each content)
    }
}

extension HavingBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: HavingSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: HavingSQLExpression, Right: HavingSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: HavingSQLExpression, Right: HavingSQLExpression {
        .right(content)
    }
}
