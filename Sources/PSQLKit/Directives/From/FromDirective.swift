// FromDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct FromDirective<T: FromSQLExpression>: SQLExpression {
    let content: T
    
    init(_ content: T) {
        self.content = content
    }
    
    public init(@FromBuilder content: () -> T) {
        self.content = content()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("FROM")
        serializer.writeSpace()
        content.fromSqlExpression.serialize(to: &serializer)
    }

}

extension FromDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
