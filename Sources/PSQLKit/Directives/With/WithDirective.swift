// WithDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct WithDirective<T: WithSQLExpression>: SQLExpression {
    let content: T
    
    init(_ content: T) {
        self.content = content
    }
    
    init(@WithBuilder content: () -> T) {
        self.content = content()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("WITH")
        serializer.writeSpace()
        content.withSqlExpression.serialize(to: &serializer)
    }
}

extension WithDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
