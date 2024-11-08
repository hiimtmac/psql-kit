// Macros.swift
// Copyright (c) 2024 hiimtmac inc.

@attached(peer)
public macro CTECol(
    _ name: String
) = #externalMacro(
    module: "PSQLKitMacros",
    type: "ColumnMacro"
)

@attached(peer)
public macro CTEIgnore() = #externalMacro(
    module: "PSQLKitMacros",
    type: "IgnoreMacro"
)

@attached(extension, conformances: Table, names: named(queryContainer), named(tableName), named(schemaName))
@attached(member, names: named(QueryContainer))
public macro CTE(
    _ tableName: String,
    schemaName: String? = nil
) = #externalMacro(
    module: "PSQLKitMacros",
    type: "TableMacro"
)
