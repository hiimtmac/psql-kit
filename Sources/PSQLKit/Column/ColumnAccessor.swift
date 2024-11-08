//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-04.
//

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
