// InsertDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct InsertDirective<Table: FromSQLExpression, T: InsertSQLExpression>: SQLExpression {
    let table: Table
    let content: T
    
    init(into table: Table, content: T) {
        self.table = table
        self.content = content
    }

    public init(into table: Table, @InsertBuilder content: () -> T) {
        self.table = table
        self.content = content()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.insertIsNull else { return }
        serializer.write("INSERT INTO")
        serializer.writeSpace()
        self.table.fromSqlExpression.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write("(")
        content.insertColumnSqlExpression.serialize(to: &serializer)
        serializer.write(")")
        serializer.writeSpace()
        serializer.write("VALUES")
        serializer.writeSpace()
        serializer.write("(")
        content.insertValueSqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension InsertDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
