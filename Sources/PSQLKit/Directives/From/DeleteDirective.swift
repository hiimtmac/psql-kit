// DeleteDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import struct SQLKit.SQLSerializer
import protocol SQLKit.SQLExpression

public struct DeleteDirective<T: FromSQLExpression>: SQLExpression {
    let content: T
    
    init(_ content: T) {
        self.content = content
    }
    
    public init(@FromBuilder content: () -> T) {
        self.content = content()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.fromIsNull else { return }
        serializer.write("DELETE FROM")
        serializer.writeSpace()
        content.fromSqlExpression.serialize(to: &serializer)
    }

}

extension DeleteDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
