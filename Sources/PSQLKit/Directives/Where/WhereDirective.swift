// WhereDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct WhereDirective: SQLExpression {
    let content: [WhereSQLExpression]

    public init(@WhereBuilder builder: () -> [WhereSQLExpression]) {
        self.content = builder()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        if !self.content.isEmpty {
            serializer.write("WHERE")
            serializer.writeSpace()
            SQLList(self.content.map(\.whereSqlExpression), separator: SQLRaw(" AND "))
                .serialize(to: &serializer)
        }
    }
}

extension WhereDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
