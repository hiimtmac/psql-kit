// GroupByDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct GroupByDirective<T: GroupBySQLExpression>: SQLExpression {
    let content: T
    
    init(_ content: T) {
        self.content = content
    }
    
    public init(@GroupByBuilder content: () -> T) {
        self.content = content()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.groupByIsNull else { return }
        serializer.write("GROUP BY")
        serializer.writeSpace()
        content.groupBySqlExpression.serialize(to: &serializer)
    }
}

extension GroupByDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
