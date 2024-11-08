// ColumnAccessor.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation

@propertyWrapper
public struct ColumnAccessor<Value>: Sendable {
    let column: String

    public init(_ column: String) {
        self.column = column
    }

    public var wrappedValue: Never {
        fatalError("Use $projectedValue instead.")
    }

    public var projectedValue: Self { self }
}
