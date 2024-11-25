// PostgresDataType+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

extension PostgresDataType {
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
