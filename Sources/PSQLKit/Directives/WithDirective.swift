// WithDirective.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct WithDirective<T>: SQLExpression where T: WithSQLExpression & Sendable {
    let content: T

    init(_ content: T) {
        self.content = content
    }

    public init(@WithBuilder content: () -> T) {
        self.content = content()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.withIsNull else { return }
        serializer.write("WITH")
        serializer.writeSpace()
        content.withSqlExpression.serialize(to: &serializer)
    }
}

extension WithDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
