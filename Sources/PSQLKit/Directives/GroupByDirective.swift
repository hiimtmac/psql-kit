// GroupByDirective.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct GroupByDirective<T>: SQLExpression where T: GroupBySQLExpression & Sendable {
    let content: T

    init(_ content: T) {
        self.content = content
    }

    public init(@GroupByBuilder content: () -> T) {
        self.content = content()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.groupByIsNull else { return }
        serializer.write("GROUP BY")
        serializer.writeSpace()
        content.groupBySqlExpression.serialize(to: &serializer)
    }
}

extension GroupByDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
