// JsonOperations.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct JSONFieldAccess<each T>: Sendable where repeat each T: Sendable & BaseSQLExpression {
    let content: (repeat each T)

    init(_ content: repeat each T) {
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

public func --><T, U>(
    _ base: T,
    _ expr: U
) -> JSONFieldAccess<T, U> where T: SelectSQLExpression, U: BaseSQLExpression {
    JSONFieldAccess(base, expr)
}

public func --><each T, U>(
    _ tuple: JSONFieldAccess<repeat each T>,
    _ expr: U
) -> JSONFieldAccess<repeat each T, U> where repeat each T: BaseSQLExpression, U: BaseSQLExpression {
    JSONFieldAccess(repeat each tuple.content, expr)
}

public func -->><T, U>(
    _ base: T,
    _ expr: U
) -> JSONFieldTextAccess where T: SelectSQLExpression & BaseSQLExpression, U: BaseSQLExpression {
    JSONFieldTextAccess(base, accessor: expr)
}

public func -->><each T, U>(
    _ tuple: JSONFieldAccess<repeat each T>,
    _ expr: U
) -> JSONFieldTextAccess where repeat each T: BaseSQLExpression, U: BaseSQLExpression {
    JSONFieldTextAccess(tuple, accessor: expr)
}
