// InsertDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct InsertDirective<Table>: SQLExpression where Table: FromSQLExpression {
    let table: Table
    let content: [any InsertSQLExpression]

    public init(into table: Table, @InsertBuilder builder: () -> [any InsertSQLExpression]) {
        self.table = table
        self.content = builder()
    }

    public func serialize(to serializer: inout SQLSerializer) {
//        if !self.content.isEmpty {
//            serializer.write("INSERT INTO")
//            serializer.writeSpace()
//            self.table.fromSqlExpression.serialize(to: &serializer)
//            serializer.writeSpace()
//            serializer.write("(")
//            SQLList(self.content.map(\.insertColumnSqlExpression))
//                .serialize(to: &serializer)
//            serializer.write(")")
//            serializer.writeSpace()
//            serializer.write("VALUES")
//            serializer.writeSpace()
//            serializer.write("(")
//            SQLList(self.content.map(\.insertValueSqlExpression))
//                .serialize(to: &serializer)
//            serializer.write(")")
//        }
    }
}

extension InsertDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
