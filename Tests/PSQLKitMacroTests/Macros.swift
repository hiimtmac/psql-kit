import SwiftSyntaxMacros
import PSQLKitMacros

let testMacros: [String: Macro.Type] = [
    "CTECol": ColumnMacro.self,
    "CTE": TableMacro.self,
    "CTEIgnore": IgnoreMacro.self
]
