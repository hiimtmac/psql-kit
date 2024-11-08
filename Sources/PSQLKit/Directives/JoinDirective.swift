// JoinDirective.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct JoinDirective<Table, T>: SQLExpression where Table: FromSQLExpression & Sendable, T: JoinSQLExpression & Sendable {
    let table: Table
    let method: SQLJoinMethod
    let content: T

    init(_ table: Table, method: SQLJoinMethod = .inner, content: T) {
        self.table = table
        self.method = method
        self.content = content
    }

    public init(_ table: Table, method: SQLJoinMethod = .inner, @JoinBuilder content: () -> T) {
        self.table = table
        self.method = method
        self.content = content()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.joinIsNull else { return }
        self.method.serialize(to: &serializer)
        serializer.writeSpaced("JOIN")
        self.table.fromSqlExpression.serialize(to: &serializer)
        serializer.writeSpaced("ON")
        content.joinSqlExpression.serialize(to: &serializer)
    }
}

extension JoinDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
