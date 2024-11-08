// ColumnMacro.swift
// Copyright (c) 2024 hiimtmac inc.

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ColumnMacro {}

extension ColumnMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        []
    }
}
