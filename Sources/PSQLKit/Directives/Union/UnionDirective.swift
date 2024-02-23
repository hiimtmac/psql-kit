// UnionDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct UnionDirective<T: UnionSQLExpression>: SQLExpression {
    let content: T
    
    init(_ content: T) {
        self.content = content
    }
    
    init(@UnionBuilder content: () -> T) {
        self.content = content()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        content.unionSqlExpression.serialize(to: &serializer)
    }
}

extension UnionDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
