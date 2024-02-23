// HavingDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct HavingDirective<T: HavingSQLExpression>: SQLExpression {
    let content: T
    
    init(_ content: T) {
        self.content = content
    }
    
    public init(@HavingBuilder content: () -> T) {
        self.content = content()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.havingIsNull else { return }
        serializer.write("HAVING")
        serializer.writeSpace()
        content.havingSqlExpression.serialize(to: &serializer)
    }
}

extension HavingDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
