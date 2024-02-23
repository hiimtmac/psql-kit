//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2024-02-22.
//

import Foundation
import SQLKit

struct SelectTouple<each T: SelectSQLExpression>: SelectSQLExpression {
    let content: (repeat each T)
    
    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
    
    var selectIsNull: Bool {
        selectSqlExpression.expressions.isEmpty
    }
    
    var selectSqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
}

extension _ConditionalContent: SelectSQLExpression where T: SelectSQLExpression, U: SelectSQLExpression {
    
    var selectSqlExpression: some SQLExpression {
        _Select(content: self)
    }
    
    struct _Select: SQLExpression {
        let content: _ConditionalContent<T, U>
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .left(let t): t.selectSqlExpression.serialize(to: &serializer)
            case .right(let u): u.selectSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
enum SelectBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: SelectSQLExpression {
        content
    }

//    public static func buildBlock() -> EmptyView {
//        EmptyView()
//    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: SelectSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> SelectTouple<repeat each Content> where repeat each Content: SelectSQLExpression {
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
