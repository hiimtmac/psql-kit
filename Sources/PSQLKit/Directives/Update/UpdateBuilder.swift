// UpdateBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw

struct UpdateTouple<each T: UpdateSQLExpression>: UpdateSQLExpression {
    let content: (repeat each T)
    
    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
    
    var updateIsNull: Bool {
        updateSqlExpression.expressions.isEmpty
    }
    
    var updateSqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
}

extension _ConditionalContent: UpdateSQLExpression where T: UpdateSQLExpression, U: UpdateSQLExpression {
    
    var updateSqlExpression: some SQLExpression {
        _Update(content: self)
    }
    
    struct _Update: SQLExpression {
        let content: _ConditionalContent<T, U>
        
        func serialize(to serializer: inout SQLSerializer) {
            switch content {
            case .left(let t): t.updateSqlExpression.serialize(to: &serializer)
            case .right(let u): u.updateSqlExpression.serialize(to: &serializer)
            }
        }
    }
}

@resultBuilder
enum UpdateBuilder {
    public static func buildExpression<Content>(
        _ content: Content
    ) -> Content where Content: UpdateSQLExpression {
        content
    }

//    public static func buildBlock() -> EmptyView {
//        EmptyView()
//    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: UpdateSQLExpression {
        content
    }

    @_disfavoredOverload
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> UpdateTouple<repeat each Content> where repeat each Content: UpdateSQLExpression {
        .init(repeat each content)
    }
}

extension UpdateBuilder {
    public static func buildIf<Content>(
        _ content: Content?
    ) -> Content? where Content: UpdateSQLExpression {
        content
    }

    public static func buildEither<Left, Right>(
        first content: Left
    ) -> _ConditionalContent<Left, Right> where Left: UpdateSQLExpression, Right: UpdateSQLExpression {
        .left(content)
    }

    public static func buildEither<Left, Right>(
        second content: Right
    ) -> _ConditionalContent<Left, Right> where Left: UpdateSQLExpression, Right: UpdateSQLExpression {
        .right(content)
    }
}
