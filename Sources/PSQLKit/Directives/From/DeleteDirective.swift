// DeleteDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct DeleteDirective: SQLExpression {
    let content: [FromSQLExpression]

    public init(@FromBuilder builder: () -> [FromSQLExpression]) {
        self.content = builder()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        if !self.content.isEmpty {
            serializer.write("DELETE FROM")
            serializer.writeSpace()
            SQLList(self.content.map(\.fromSqlExpression))
                .serialize(to: &serializer)
        }
    }
}

extension DeleteDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
