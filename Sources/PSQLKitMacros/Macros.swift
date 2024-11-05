import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct PSQLKitPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ColumnMacro.self,
        IgnoreMacro.self,
        TableMacro.self
    ]
}
