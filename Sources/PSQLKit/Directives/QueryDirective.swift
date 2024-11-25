// QueryDirective.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct QueryDirective<T>: SQLExpression where T: QuerySQLExpression & Sendable {
    let content: T

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

    init(name: String, content: T) {
        self.name = name
        self.content = content
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.queryIsNull else { return }
        serializer.write("(")
        content.querySqlExpression.serialize(to: &serializer)
        serializer.write(")")
        serializer.writeSpaced("AS")
        serializer.writeIdentifier(self.name)
    }
}

extension QueryDirective {
    public func asSubquery<U>(_ table: TableInstance<U>) -> SubQuery<T> where U: Table {
        SubQuery(name: U.tableName, content: self.content)
    }

    public func asSubquery<U>(_ alias: TableAlias<U>) -> SubQuery<T> where U: Table {
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
    let content: T

    init(name: String, content: T) {
        self.name = name
        self.content = content
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.queryIsNull else { return }
        serializer.writeIdentifier(self.name)
        serializer.writeSpaced("AS")
        serializer.write("(")
        content.querySqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension QueryDirective {
    public func asWith<U>(_ table: TableInstance<U>) -> WithQuery<T> where U: Table {
        WithQuery(name: U.tableName, content: self.content)
    }

    public func asWith<U>(_ alias: TableAlias<U>) -> WithQuery<T> {
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
