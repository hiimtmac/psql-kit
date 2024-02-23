// TableObject.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType

public protocol TableObject: PSQLExpression {
    init()
}

extension TableObject {
    public static var postgresDataType: PostgresDataType { .jsonb }
    public typealias Column<Value> = ColumnProperty<Self, Value> where Value: Codable
    public typealias OptionalColumn<Value> = OptionalColumnProperty<Self, Value> where Value: Codable
    public typealias NestedColumn<Value> = NestedObjectProperty<Self, Value> where Value: Codable
}
