// UpdateDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct UpdateDirective<Table>: SQLExpression where Table: FromSQLExpression {
    let table: Table
    let content: [any UpdateSQLExpression]

    public init(_ table: Table, @UpdateBuilder builder: () -> [any UpdateSQLExpression]) {
        self.table = table
        self.content = builder()
    }

    public func serialize(to serializer: inout SQLSerializer) {
//        if !self.content.isEmpty {
//            serializer.write("UPDATE")
//            serializer.writeSpace()
//            self.table.fromSqlExpression.serialize(to: &serializer)
//            serializer.writeSpace()
//            serializer.write("SET")
//            serializer.writeSpace()
//            SQLList(self.content.map(\.updateSqlExpression))
//                .serialize(to: &serializer)
//        }
    }
}

extension UpdateDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
