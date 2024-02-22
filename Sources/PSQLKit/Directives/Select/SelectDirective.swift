// SelectDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

// https://github.com/apple/swift-evolution/blob/main/proposals/0289-result-builders.md

public struct EmptySelection: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        SQLRaw("")
    }
}

struct SelectTouple<each T: SelectSQLExpression>: SelectSQLExpression {
    let content: (repeat each T)
    
    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
    
    var selectSqlExpression: SQLList {
        // required until swift 6 https://github.com/apple/swift-evolution/blob/main/proposals/0408-pack-iteration.md
        var collector = Collector()
        _ = (repeat collector.append(exp: each content))
        return SQLList(collector.expressions, separator: SQLRaw(", "))
    }
    
    struct Collector {
        var expressions: [any SQLExpression] = []
        
        mutating func append(exp: some SelectSQLExpression) {
            guard !exp.isNull else { return }
            expressions.append(exp.selectSqlExpression)
        }
    }
}

enum _ConditionalContent<T: SelectSQLExpression, U: SelectSQLExpression>: SelectSQLExpression {
    case left(T)
    case right(U)
    
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

public struct SelectDirective<T: SelectSQLExpression>: SelectSQLExpression, SQLExpression {
    let content: T
    
    init(_ content: T) {
        self.content = content
    }
    
    init(@SelectBuilder content: () -> T) {
        self.content = content()
    }
    
    public var selectSqlExpression: some SQLExpression {
        content.selectSqlExpression
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("SELECT")
        serializer.writeSpace()
        content.selectSqlExpression.serialize(to: &serializer)
    }
}

public struct SelectModifier<T: SelectSQLExpression, U: SelectSQLExpression>: SQLExpression {
    let select: SelectDirective<T>
    let modifier: U
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("SELECT")
        serializer.writeSpace()
        
        modifier.selectSqlExpression.serialize(to: &serializer)
        serializer.writeSpace()
        
        select.selectSqlExpression.serialize(to: &serializer)
    }
}

public struct DistinctModifier<T: SelectSQLExpression>: SelectSQLExpression {
    let content: T
    
    init(_ content: T) {
        self.content = content
    }
    
    init(@SelectBuilder content: () -> T) {
        self.content = content()
    }
    
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content)
    }
    
    private struct _Select: SQLExpression {
        let content: T
        
        func serialize(to serializer: inout SQLSerializer) {
            if T.self == EmptySelection.self {
                serializer.write("DISTINCT")
            } else {
                serializer.write("DISTINCT ON")
                serializer.writeSpace()
                serializer.write("(")
                content.selectSqlExpression.serialize(to: &serializer)
                serializer.write(")")
            }
        }
    }
}

extension SelectDirective {
    /// Select Distinct
    ///
    /// ```sql
    /// SELECT DISTINCT first_name, last_name
    /// FROM people
    /// ```
    public func distinct() -> SelectModifier<T, DistinctModifier<EmptySelection>> {
        SelectModifier(select: self, modifier: DistinctModifier(content: EmptySelection.init))
    }
}

extension SelectDirective {
    /// Select Distinct On
    /// 
    /// ```sql
    /// SELECT DISTINCT ON (address_id) *
    /// FROM purchases
    /// WHERE product_id = 1
    /// ORDER BY address_id, purchased_at DESC
    /// ```
    public func distinct<U>(@SelectBuilder content: () -> U) -> SelectModifier<T, DistinctModifier<U>> {
        SelectModifier(select: self, modifier: DistinctModifier(content: content))
    }
}

extension SelectDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}

extension SelectModifier: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
