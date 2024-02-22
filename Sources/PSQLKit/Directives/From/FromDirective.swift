// FromDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct FromDirective: SQLExpression {
    let content: [any FromSQLExpression]

    public init(@FromBuilder builder: () -> [any FromSQLExpression]) {
        self.content = builder()
    }

    public func serialize(to serializer: inout SQLSerializer) {
//        if !self.content.isEmpty {
//            serializer.write("FROM")
//            serializer.writeSpace()
//            SQLList(self.content.map(\.fromSqlExpression))
//                .serialize(to: &serializer)
//        }
    }
}

extension FromDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
