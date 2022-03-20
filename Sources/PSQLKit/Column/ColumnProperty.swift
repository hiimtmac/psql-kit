// ColumnProperty.swift
// Copyright © 2022 hiimtmac

import Foundation

@propertyWrapper
public struct ColumnProperty<Table, Value>: Codable where
    Value: Codable
{
    let key: String

    public init(key: String) {
        self.key = key
    }

    public var projectedValue: Self { self }

    public var wrappedValue: Value {
        fatalError("Not to be accessed. Query only")
    }
}

@propertyWrapper
public struct OptionalColumnProperty<Table, WrappedValue>: Codable where
    WrappedValue: Codable
{
    let key: String

    public init(key: String) {
        self.key = key
    }

    public var projectedValue: Self { self }

    public var wrappedValue: WrappedValue? {
        fatalError("Not to be accessed. Query only")
    }
}

@propertyWrapper
public struct NestedObjectProperty<Table, Nested>: Codable where
    Nested: Codable
{
    let key: String

    public init(key: String) {
        self.key = key
    }

    public var projectedValue: Self { self }

    public var wrappedValue: Nested {
        fatalError("Not to be accessed. Query only")
    }
}
