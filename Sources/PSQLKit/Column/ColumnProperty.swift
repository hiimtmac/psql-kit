import Foundation

@propertyWrapper
public struct ColumnProperty<Model: Table, Value: PSQLExpressible> {
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
public struct OptionalColumnProperty<Model: Table, WrappedValue: PSQLExpressible> {
    let key: String
    
    public init(key: String) {
        self.key = key
    }
    
    public var projectedValue: Self { self }
    
    public var wrappedValue: WrappedValue? {
        fatalError("Not to be accessed. Query only")
    }
}
