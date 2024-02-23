// JoinDirective.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import protocol SQLKit.SQLExpression
import enum SQLKit.SQLJoinMethod
import struct SQLKit.SQLSerializer

public struct JoinDirective<Table: FromSQLExpression, T: JoinSQLExpression>: SQLExpression {
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
        serializer.writeSpace()
        serializer.write("JOIN")
        serializer.writeSpace()
        self.table.fromSqlExpression.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write("ON")
        serializer.writeSpace()
        content.joinSqlExpression.serialize(to: &serializer)
    }
}

extension JoinDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
