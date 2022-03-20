// OrderByDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public enum OrderByDirection: String, SQLExpression {
    case asc = "ASC"
    case desc = "DESC"

    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write(rawValue)
    }
}

public struct OrderByDirective: SQLExpression {
    let content: [OrderBySQLExpression]

    public init(@OrderByBuilder builder: () -> [OrderBySQLExpression]) {
        self.content = builder()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        if !self.content.isEmpty {
            serializer.write("ORDER BY")
            serializer.writeSpace()
            SQLList(self.content.map(\.orderBySqlExpression))
                .serialize(to: &serializer)
        }
    }
}

public struct OrderByModifier<Content>: OrderBySQLExpression where Content: OrderBySQLExpression {
    let content: Content
    let direction: OrderByDirection

    private struct _OrderBy: SQLExpression {
        let content: Content
        let direction: OrderByDirection

        func serialize(to serializer: inout SQLSerializer) {
            self.content.orderBySqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            self.direction.serialize(to: &serializer)
        }
    }

    public var orderBySqlExpression: SQLExpression {
        _OrderBy(content: self.content, direction: self.direction)
    }
}

extension OrderByDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
