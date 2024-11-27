//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-27.
//

import SQLKit

public struct JSONFieldTextAccess: Sendable {
    let accessors: SQLList
    let accessor: any SQLExpression

    init<each T, U>(_ content: repeat each T, accessor: U) where
        repeat each T: BaseSQLExpression,
        U: BaseSQLExpression
    {
        self.accessors = SQLList(arrowSQLExpressions: repeat each content)
        self.accessor = accessor.baseSqlExpression
    }
}

extension JSONFieldTextAccess: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        _Base(accessors: self.accessors, accessor: self.accessor)
    }
    
    struct _Base: SQLExpression {
        let accessors: SQLList
        let accessor: any SQLExpression
        
        func serialize(to serializer: inout SQLSerializer) {
            accessors.serialize(to: &serializer)
            serializer.write("->>")
            accessor.serialize(to: &serializer)
        }
    }
}

extension JSONFieldTextAccess: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Select(accessors: self.accessors, accessor: self.accessor)
    }
    
    struct _Select: SQLExpression {
        let accessors: SQLList
        let accessor: any SQLExpression
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("(")
            accessors.serialize(to: &serializer)
            serializer.write("->>")
            accessor.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeCast(.text)
        }
    }
}

extension JSONFieldTextAccess {
    public func `as`(_ alias: String) -> ExpressionAlias<JSONFieldTextAccess> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension JSONFieldTextAccess: TypeEquatable {
    public typealias CompareType = String
}
