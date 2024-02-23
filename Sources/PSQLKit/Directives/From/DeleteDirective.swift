// DeleteDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct DeleteDirective<T: FromSQLExpression>: SQLExpression {
    let content: T
    
    init(_ content: T) {
        self.content = content
    }
    
    public init(@FromBuilder content: () -> T) {
        self.content = content()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("DELETE FROM")
        serializer.writeSpace()
        content.fromSqlExpression.serialize(to: &serializer)
    }

}

extension DeleteDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
