import Foundation

@propertyWrapper
public struct ColumnProperty<Table, Value> {
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
public struct OptionalColumnProperty<Table, WrappedValue> {
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
public struct NestedObjectProperty<Table, Nested> {
    let key: String

    public init(key: String) {
        self.key = key
    }

    public var projectedValue: Self { self }

    public var wrappedValue: Nested {
        fatalError("Not to be accessed. Query only")
    }
}
