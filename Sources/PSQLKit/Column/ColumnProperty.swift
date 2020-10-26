import Foundation

@propertyWrapper
public struct ColumnProperty<Model: Table, Value: PSQLExpression> {
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
public struct OptionalColumnProperty<Model: Table, WrappedValue: PSQLExpression> {
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
public struct NestedObjectProperty<Model: Table, Nested: TableObject> {
    let key: String

    public init(key: String) {
        self.key = key
    }

    public var projectedValue: Self { self }

    public var wrappedValue: Nested {
        fatalError("Not to be accessed. Query only")
    }
}
