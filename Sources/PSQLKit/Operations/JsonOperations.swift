// JsonFieldAccessOperations.swift
// Copyright (c) 2024 hiimtmac inc.

// MARK: ->

public func --><T, U>(
    _ column: ColumnExpression<T>,
    _ expr: U
) -> JSONFieldAccess<ColumnExpression<T>, U, U> where T: _JSONCol, U: BaseSQLExpression {
    JSONFieldAccess(column, expr)
}

@_disfavoredOverload
public func --><T, U>(
    _ base: T,
    _ expr: U
) -> JSONFieldAccess<T, U, U> where T: BaseSQLExpression, U: BaseSQLExpression {
    JSONFieldAccess(base, expr)
}

public func --><each T, U, V>(
    _ tuple: JSONFieldAccess<repeat each T, U>,
    _ expr: V
) -> JSONFieldAccess<repeat each T, V, V> where repeat each T: BaseSQLExpression, V: BaseSQLExpression {
    JSONFieldAccess(repeat each tuple.content, expr)
}

// MARK: ->>

public func -->><T, U>(
    _ column: ColumnExpression<T>,
    _ expr: U
) -> JSONFieldTextAccess where T: _JSONCol, U: BaseSQLExpression {
    JSONFieldTextAccess(column, accessor: expr)
}

@_disfavoredOverload
public func -->><T, U>(
    _ base: T,
    _ expr: U
) -> JSONFieldTextAccess where T: SelectSQLExpression & BaseSQLExpression, U: BaseSQLExpression {
    JSONFieldTextAccess(base, accessor: expr)
}

public func -->><each T, U, V>(
    _ tuple: JSONFieldAccess<repeat each T, U>,
    _ expr: V
) -> JSONFieldTextAccess where repeat each T: BaseSQLExpression, V: BaseSQLExpression {
    JSONFieldTextAccess(tuple, accessor: expr)
}
