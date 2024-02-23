//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2024-02-22.
//

import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer
import struct PostgresNIO.PostgresDataType

extension PostgresDataType: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        guard let knownSQLName else { return }
        serializer.write("::")
        serializer.write(knownSQLName)
    }
    
    static func array(_ type: Self) -> Self {
        switch type {
        case .text: .textArray
        case .numeric: .numericArray
        case .int4: .int4Array
        case .uuid: .uuidArray
        case .bool: .boolArray
        default: fatalError("Unsupported array type for: \(type.rawValue)")
        }
    }
}
