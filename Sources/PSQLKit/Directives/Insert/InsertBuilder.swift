// InsertBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

struct InsertTouple<each T: InsertSQLExpression>: InsertSQLExpression {
    let content: (repeat each T)
    
    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
    
    var insertIsNull: Bool {
        insertColumnSqlExpression.expressions.isEmpty && insertValueSqlExpression.expressions.isEmpty
    }
    
    var insertColumnSqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(column: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
    
    var insertValueSqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(value: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
}

extension _ConditionalContent: InsertSQLExpression where T: InsertSQLExpression, U: InsertSQLExpression {
    
    var insertColumnSqlExpression: some SQLExpression {
        _InsertColumn(content: self)
    }
    
    struct _InsertColumn: SQLExpression {
        let content: _ConditionalContent<T, U>
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .left(let t): t.insertColumnSqlExpression.serialize(to: &serializer)
            case .right(let u): u.insertColumnSqlExpression.serialize(to: &serializer)
            }
        }
    }
    
    var insertValueSqlExpression: some SQLExpression {
        _InsertValue(content: self)
    }
    
    struct _InsertValue: SQLExpression {
        let content: _ConditionalContent<T, U>
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .left(let t): t.insertValueSqlExpression.serialize(to: &serializer)
            case .right(let u): u.insertValueSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
enum InsertBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: InsertSQLExpression {
        content
    }

//    public static func buildBlock() -> EmptyView {
//        EmptyView()
//    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: InsertSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> InsertTouple<repeat each Content> where repeat each Content: InsertSQLExpression {
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
