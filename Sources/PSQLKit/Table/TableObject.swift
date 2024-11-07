// TableObject.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType

#warning("figure out")

public protocol NestedCTE: CTE, PSQLExpression, Decodable {}

extension NestedCTE {
    public static var postgresDataType: PostgresDataType { .jsonb }
}

public protocol TableObject: PSQLExpression {}

extension TableObject {
    public static var postgresDataType: PostgresDataType { .jsonb }
    public typealias Column<Value> = ColumnProperty<Self, Value> where Value: Codable
    public typealias OptionalColumn<Value> = OptionalColumnProperty<Self, Value> where Value: Codable
    public typealias NestedColumn<Value> = NestedObjectProperty<Self, Value> where Value: Codable
}
