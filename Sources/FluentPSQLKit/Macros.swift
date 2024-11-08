// Macros.swift
// Copyright (c) 2024 hiimtmac inc.

@attached(extension, conformances: FluentCTE, names: named(schema), named(space))
public macro FluentCTE(
    _ tableName: String,
    schemaName: String? = nil
) = #externalMacro(
    module: "PSQLKitMacros",
    type: "FluentTableMacro"
)
