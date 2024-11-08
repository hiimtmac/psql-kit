// TableObject.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType

public protocol NestedCTE: PSQLExpression, Decodable {}

extension NestedCTE {
    public static var postgresDataType: PostgresDataType { .jsonb }
}
