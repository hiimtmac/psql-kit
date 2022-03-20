// UnionDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct UnionDirective: SQLExpression {
    let content: [UnionSQLExpression]

    public init(@UnionBuilder builder: () -> [UnionSQLExpression]) {
        self.content = builder()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        if !self.content.isEmpty {
            SQLList(self.content.map(\.unionSqlExpression), separator: SQLRaw(" UNION "))
                .serialize(to: &serializer)
        }
    }
}

extension UnionDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
