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

public struct OrderByDirective<T: OrderBySQLExpression>: SQLExpression {
    let content: T
    
    init(_ content: T) {
        self.content = content
    }
    
    public init(@OrderByBuilder content: () -> T) {
        self.content = content()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.orderByIsNull else { return }
        serializer.write("ORDER BY")
        serializer.writeSpace()
        content.orderBySqlExpression.serialize(to: &serializer)
    }
}

public struct OrderByModifier<Content: OrderBySQLExpression>: OrderBySQLExpression {
    let content: Content
    let direction: OrderByDirection

    private struct _OrderBy: SQLExpression {
        let content: Content
        let direction: OrderByDirection

        func serialize(to serializer: inout SQLSerializer) {
            guard !content.orderByIsNull else { return }
            self.content.orderBySqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            self.direction.serialize(to: &serializer)
        }
    }

    public var orderBySqlExpression: some SQLExpression {
        _OrderBy(content: self.content, direction: self.direction)
    }
}

extension OrderByDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
