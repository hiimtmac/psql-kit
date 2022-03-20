// WithDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct WithDirective: SQLExpression {
    let content: [WithSQLExpression]

    public init(@WithBuilder builder: () -> [WithSQLExpression]) {
        self.content = builder()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        if !self.content.isEmpty {
            serializer.write("WITH")
            serializer.writeSpace()
            SQLList(self.content.map(\.withSqlExpression))
                .serialize(to: &serializer)
        }
    }
}

extension WithDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
