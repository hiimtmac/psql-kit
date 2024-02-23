// WhereDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct WhereDirective<T: WhereSQLExpression>: SQLExpression {
    let content: T
    
    init(_ content: T) {
        self.content = content
    }
    
    public init(@WhereBuilder content: () -> T) {
        self.content = content()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.whereIsNull else { return }
        serializer.write("WHERE")
        serializer.writeSpace()
        content.whereSqlExpression.serialize(to: &serializer)
    }
}

extension WhereDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
