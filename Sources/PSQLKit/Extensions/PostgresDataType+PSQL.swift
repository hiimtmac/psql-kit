// PostgresDataType+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

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
