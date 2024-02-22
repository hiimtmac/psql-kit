// JoinDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct JoinDirective<Table>: SQLExpression where Table: FromSQLExpression {
    let table: Table
    let method: SQLJoinMethod
    let content: [any JoinSQLExpression]

    public init(_ table: Table, method: SQLJoinMethod = .inner, @JoinBuilder builder: () -> [any JoinSQLExpression]) {
        self.table = table
        self.method = method
        self.content = builder()
    }

    public func serialize(to serializer: inout SQLSerializer) {
//        if !self.content.isEmpty {
//            self.method.serialize(to: &serializer)
//            serializer.writeSpace()
//            serializer.write("JOIN")
//            serializer.writeSpace()
//            self.table.fromSqlExpression.serialize(to: &serializer)
//            serializer.writeSpace()
//            serializer.write("ON")
//            serializer.writeSpace()
//            SQLList(self.content.map(\.joinSqlExpression), separator: SQLRaw(" AND "))
//                .serialize(to: &serializer)
//        }
    }
}

extension JoinDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
