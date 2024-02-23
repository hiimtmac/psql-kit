// HavingDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct HavingDirective<T: HavingSQLExpression>: SQLExpression {
    let content: T
    
    init(_ content: T) {
        self.content = content
    }
    
    init(@HavingBuilder content: () -> T) {
        self.content = content()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("HAVING")
        serializer.writeSpace()
        content.havingSqlExpression.serialize(to: &serializer)
    }
}

extension HavingDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
