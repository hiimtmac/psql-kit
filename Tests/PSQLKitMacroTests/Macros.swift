// Macros.swift
// Copyright (c) 2024 hiimtmac inc.

import PSQLKitMacros
import SwiftSyntaxMacros

let testMacros: [String: Macro.Type] = [
    "CTECol": ColumnMacro.self,
    "CTE": TableMacro.self,
    "CTEIgnore": IgnoreMacro.self,
    "FluentCTE": FluentTableMacro.self
]
