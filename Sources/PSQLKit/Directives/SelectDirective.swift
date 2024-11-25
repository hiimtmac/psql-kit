// SelectDirective.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

// https://github.com/apple/swift-evolution/blob/main/proposals/0289-result-builders.md

public struct SelectDirective<T>: SelectSQLExpression, SQLExpression, Sendable where T: SelectSQLExpression & Sendable {
    let content: T

    init(_ content: T) {
        self.content = content
    }
    
    public init(_ scope: SelectScope) where T == SelectScope {
        self.content = scope
    }

    public init(@SelectBuilder content: () -> T) {
        self.content = content()
    }

    public var selectSqlExpression: some SQLExpression {
        content.selectSqlExpression
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.selectIsNull else { return }
        serializer.write("SELECT")
        serializer.writeSpace()
        content.selectSqlExpression.serialize(to: &serializer)
    }
}

public enum SelectScope: SelectSQLExpression {
    case all
    
    public var selectSqlExpression: some SQLExpression {
        _Select()
    }

    struct _Select: SQLExpression {
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("*")
        }
    }
}

public struct SelectModifier<T, U>: SQLExpression where T: SelectSQLExpression & Sendable, U: SelectSQLExpression & Sendable {
    let select: SelectDirective<T>
    let modifier: U

    public func serialize(to serializer: inout SQLSerializer) {
        guard !select.selectIsNull else { return }
        serializer.write("SELECT")
        serializer.writeSpace()

        modifier.selectSqlExpression.serialize(to: &serializer)
        serializer.writeSpace()

        select.selectSqlExpression.serialize(to: &serializer)
    }
}

public struct DistinctModifier<T>: SelectSQLExpression, Sendable where T: SelectSQLExpression & Sendable {
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

    struct _Select: SQLExpression {
        let content: T

        func serialize(to serializer: inout SQLSerializer) {
            if T.self == EmptyExpression.self {
                serializer.write("DISTINCT")
            } else {
                guard !content.selectIsNull else { return }
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
    public func distinct() -> SelectModifier<T, DistinctModifier<EmptyExpression>> {
        SelectModifier(select: self, modifier: DistinctModifier(content: EmptyExpression.init))
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
