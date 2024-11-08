// Macros.swift
// Copyright (c) 2024 hiimtmac inc.

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct PSQLKitPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ColumnMacro.self,
        IgnoreMacro.self,
        TableMacro.self,
        FluentTableMacro.self
    ]
}
