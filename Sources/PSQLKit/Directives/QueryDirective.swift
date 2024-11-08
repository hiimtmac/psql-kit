// QueryDirective.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct QueryDirective<T>: SQLExpression where T: QuerySQLExpression & Sendable {
    package let content: T

    init(_ content: T) {
        self.content = content
    }

    public init(@QueryBuilder content: () -> T) {
        self.content = content()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.queryIsNull else { return }
        content.querySqlExpression.serialize(to: &serializer)
    }
}

extension QueryDirective: UnionSQLExpression {
    public var unionSqlExpression: some SQLExpression { self }
}

// MARK: - SubqueryModifier

public struct SubQuery<T>: SQLExpression where T: QuerySQLExpression & Sendable {
    let name: String
    let content: T
    
    package init(name: String, content: T) {
        self.name = name
        self.content = content
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.queryIsNull else { return }
        serializer.write("(")
        content.querySqlExpression.serialize(to: &serializer)
        serializer.write(")")
        serializer.writeSpace()
        serializer.write("AS")
        serializer.writeSpace()
        serializer.writeQuote()
        serializer.write(self.name)
        serializer.writeQuote()
    }
}

extension QueryDirective {
    public func asSubquery<U>(_ table: CTETable<U>) -> SubQuery<T> where U: CTE {
        SubQuery(name: U.tableName, content: self.content)
    }

    public func asSubquery<U>(_ alias: CTEAlias<U>) -> SubQuery<T> where U: CTE {
        SubQuery(name: alias.alias, content: self.content)
    }

    public func asSubquery(_ name: String) -> SubQuery<T> {
        SubQuery(name: name, content: self.content)
    }
}

extension SubQuery: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression { self }
}

extension QueryDirective: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression {
        content.querySqlExpression
    }
}

extension SubQuery: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension QueryDirective: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        content.querySqlExpression
    }
}

// MARK: - WithModifier

public struct WithQuery<T>: SQLExpression where T: QuerySQLExpression & Sendable {
    let name: String
    package let content: T
    
    package init(name: String, content: T) {
        self.name = name
        self.content = content
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.queryIsNull else { return }
        serializer.writeQuote()
        serializer.write(self.name)
        serializer.writeQuote()
        serializer.writeSpace()
        serializer.write("AS")
        serializer.writeSpace()
        serializer.write("(")
        content.querySqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension QueryDirective {
    public func asWith<U>(_ table: CTETable<U>) -> WithQuery<T> where U: CTE {
        WithQuery(name: U.tableName, content: self.content)
    }

    public func asWith<U>(_ alias: CTEAlias<U>) -> WithQuery<T> {
        WithQuery(name: alias.alias, content: self.content)
    }

    public func asWith(_ name: String) -> WithQuery<T> {
        WithQuery(name: name, content: self.content)
    }
}

extension WithQuery: WithSQLExpression {
    public var withSqlExpression: some SQLExpression { self }
}

extension QueryDirective: WithSQLExpression {
    public var withSqlExpression: some SQLExpression {
        content.querySqlExpression
    }
}
