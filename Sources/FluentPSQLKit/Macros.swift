@attached(extension, conformances: CTE, names: named(queryContainer), named(tableName), named(schemaName))
@attached(member, names: named(queryContainer), named(tableName), named(schemaName), arbitrary)
public macro FluentCTE(
    _ tableName: String,
    schemaName: String? = nil
) = #externalMacro(
    module: "PSQLKitMacros",
    type: "FluentTableMacro"
)
