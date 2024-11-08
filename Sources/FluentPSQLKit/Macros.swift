// Macros.swift
// Copyright (c) 2024 hiimtmac inc.

@attached(extension, conformances: Table, names: named(queryContainer), named(space), named(schema))
@attached(member, names: named(QueryContainer))
public macro FluentCTE(
    _ tableName: String,
    schemaName: String? = nil
) = #externalMacro(
    module: "PSQLKitMacros",
    type: "FluentTableMacro"
)
