// QueryDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct QueryDirective: SQLExpression {
    let content: [any QuerySQLExpression]

    public init(@QueryBuilder builder: () -> [any QuerySQLExpression]) {
        self.content = builder()
    }

    init(content: [any QuerySQLExpression]) {
        self.content = content
    }

    public func serialize(to serializer: inout SQLSerializer) {
//        SQLList(self.content.map(\.querySqlExpression), separator: SQLRaw(" "))
//            .serialize(to: &serializer)
    }
}

extension QueryDirective: UnionSQLExpression {
    public var unionSqlExpression: some SQLExpression { self }
}

// MARK: - SubqueryModifier

public struct SubQuery: SQLExpression {
    let name: String
    let content: [any QuerySQLExpression]

    public func serialize(to serializer: inout SQLSerializer) {
//        serializer.write("(")
//        SQLList(self.content.map(\.querySqlExpression), separator: SQLRaw(" "))
//            .serialize(to: &serializer)
//        serializer.write(")")
//        serializer.writeSpace()
//        serializer.write("AS")
//        serializer.writeSpace()
//        serializer.writeQuote()
//        serializer.write(self.name)
//        serializer.writeQuote()
    }
}

extension QueryDirective {
    public func asSubquery<T>(_ table: T) -> SubQuery where T: Table {
        SubQuery(name: type(of: table).schema, content: self.content)
    }

    public func asSubquery<T>(_ alias: TableAlias<T>) -> SubQuery where T: Table {
        SubQuery(name: alias.alias, content: self.content)
    }

    public func asSubquery(_ name: String) -> SubQuery {
        SubQuery(name: name, content: self.content)
    }
}

extension SubQuery: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression { self }
}

extension QueryDirective: FromSQLExpression {
    private struct _From: SQLExpression {
        let content: [any QuerySQLExpression]

        func serialize(to serializer: inout SQLSerializer) {
//            SQLList(self.content.map(\.querySqlExpression), separator: SQLRaw(" "))
//                .serialize(to: &serializer)
        }
    }

    public var fromSqlExpression: some SQLExpression {
        _From(content: self.content)
    }
}

extension SubQuery: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension QueryDirective: SelectSQLExpression {
    private struct _Select: SQLExpression {
        let content: [any QuerySQLExpression]

        func serialize(to serializer: inout SQLSerializer) {
//            SQLList(self.content.map(\.querySqlExpression), separator: SQLRaw(" "))
//                .serialize(to: &serializer)
        }
    }

    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content)
    }
}

// MARK: - WithModifier

public struct WithQuery: SQLExpression {
    let name: String
    let content: [any QuerySQLExpression]

    public func serialize(to serializer: inout SQLSerializer) {
//        serializer.writeQuote()
//        serializer.write(self.name)
//        serializer.writeQuote()
//        serializer.writeSpace()
//        serializer.write("AS")
//        serializer.writeSpace()
//        serializer.write("(")
//        SQLList(self.content.map(\.querySqlExpression), separator: SQLRaw(" "))
//            .serialize(to: &serializer)
//        serializer.write(")")
    }
}

extension QueryDirective {
    public func asWith<T>(_ table: T) -> WithQuery where T: Table {
        WithQuery(name: type(of: table).schema, content: self.content)
    }

    public func asWith<T>(_ alias: TableAlias<T>) -> WithQuery where T: Table {
        WithQuery(name: alias.alias, content: self.content)
    }

    public func asWith(_ name: String) -> WithQuery {
        WithQuery(name: name, content: self.content)
    }
}

extension WithQuery: WithSQLExpression {
    public var withSqlExpression: some SQLExpression { self }
}

extension QueryDirective: WithSQLExpression {
    private struct _With: SQLExpression {
        let content: [any QuerySQLExpression]

        func serialize(to serializer: inout SQLSerializer) {
//            SQLList(self.content.map(\.querySqlExpression), separator: SQLRaw(" "))
//                .serialize(to: &serializer)
        }
    }

    public var withSqlExpression: some SQLExpression {
        _With(content: self.content)
    }
}
