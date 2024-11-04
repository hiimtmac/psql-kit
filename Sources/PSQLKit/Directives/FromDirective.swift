// FromDirective.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct FromDirective<T>: SQLExpression where T: FromSQLExpression & Sendable {
    let content: T

    init(_ content: T) {
        self.content = content
    }

    public init(@FromBuilder content: () -> T) {
        self.content = content()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.fromIsNull else { return }
        serializer.write("FROM")
        serializer.writeSpace()
        content.fromSqlExpression.serialize(to: &serializer)
    }
}

extension FromDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
