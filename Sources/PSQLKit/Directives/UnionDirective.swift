// UnionDirective.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct UnionDirective<T>: SQLExpression where T: UnionSQLExpression & Sendable {
    let content: T

    init(_ content: T) {
        self.content = content
    }

    public init(@UnionBuilder content: () -> T) {
        self.content = content()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.unionIsNull else { return }
        content.unionSqlExpression.serialize(to: &serializer)
    }
}

extension UnionDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
