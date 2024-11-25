//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-25.
//

import SQLKit

public struct Record: Sendable, SQLExpression {
    let name: String?
    let columns: [ColumnDefinition]
    
    public init(
        name: String? = nil,
        columns: [ColumnDefinition]
    ) {
        self.name = name
        self.columns = columns
    }
    
//    public init<each T>(
//        name: String? = nil,
//        columns: repeat ColumnExpression<each T>
//    ) where repeat each T: PSQLExpression {
//        self.name = name
//        
//        var defs: [ColumnDefinition] = []
//        for column in repeat each columns {
//            defs.append(.init(column))
//        }
//
//        self.columns = defs
//    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if let name {
            serializer.write(name)
        }
        serializer.write("(")
        SQLList(columns, separator: SQLRaw(", ")).serialize(to: &serializer)
        serializer.write(")")
    }
}

extension Record: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: ColumnDefinition...) {
        self.init(columns: elements)
    }
}
