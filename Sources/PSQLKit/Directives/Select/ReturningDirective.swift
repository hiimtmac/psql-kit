// ReturningDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct ReturningDirective: SQLExpression {
    let content: [SelectSQLExpression]

    public init(@SelectBuilder builder: () -> [SelectSQLExpression]) {
        self.content = builder()
    }

    init(content: [SelectSQLExpression]) {
        self.content = content
    }

    public func serialize(to serializer: inout SQLSerializer) {
        if !self.content.isEmpty {
            serializer.write("RETURNING")
            serializer.writeSpace()
            SQLList(self.content.map(\.selectSqlExpression))
                .serialize(to: &serializer)
        }
    }
}

extension ReturningDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
