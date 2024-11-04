// ReturningDirective.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct ReturningDirective<T>: SQLExpression where T: SelectSQLExpression & Sendable {
    let content: T

    init(_ content: T) {
        self.content = content
    }

    public init(@SelectBuilder content: () -> T) {
        self.content = content()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.selectIsNull else { return }
        serializer.write("RETURNING")
        serializer.writeSpace()
        content.selectSqlExpression.serialize(to: &serializer)
    }
}

extension ReturningDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
