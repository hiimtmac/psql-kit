// WhereDirective.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct WhereDirective<T>: SQLExpression where T: WhereSQLExpression & Sendable {
    let content: T

    init(_ content: T) {
        self.content = content
    }

    public init(@WhereBuilder content: () -> T) {
        self.content = content()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.whereIsNull else { return }
        serializer.write("WHERE")
        serializer.writeSpace()
        content.whereSqlExpression.serialize(to: &serializer)
    }
}

extension WhereDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
