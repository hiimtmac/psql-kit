//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-27.
//

import SQLKit

public struct JSONFieldAccess<each T, U>: Sendable where repeat each T: Sendable & BaseSQLExpression {
    let content: (repeat each T)

    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
    
    init(_ content: U) where (repeat each T) == U {
        self.content = (repeat each content)
    }
}

extension JSONFieldAccess: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        SQLList(arrowSQLExpressions: repeat each content)
    }
}

extension JSONFieldAccess: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        baseSqlExpression
    }
}

extension JSONFieldAccess {
    public func `as`(_ alias: String) -> ExpressionAlias<JSONFieldAccess> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JSONFieldAccess: TypeEquatable where U: TypeEquatable {
    public typealias CompareType = U.CompareType
}
