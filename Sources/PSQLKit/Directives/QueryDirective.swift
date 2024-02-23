// QueryDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct QueryDirective<T: QuerySQLExpression>: SQLExpression {
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

public struct SubQuery<T: QuerySQLExpression>: SQLExpression {
    let name: String
    let content: T

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
    public func asSubquery<U: Table>(_ table: U) -> SubQuery<T> {
        SubQuery(name: type(of: table).schema, content: self.content)
    }

    public func asSubquery<U: Table>(_ alias: TableAlias<U>) -> SubQuery<T> {
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

public struct WithQuery<T: QuerySQLExpression>: SQLExpression {
    let name: String
    let content: T

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
    public func asWith<U: Table>(_ table: U) -> WithQuery<T> {
        WithQuery(name: type(of: table).schema, content: self.content)
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
