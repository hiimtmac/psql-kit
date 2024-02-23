// TableObject.swift
// Copyright © 2022 hiimtmac

import Foundation
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
