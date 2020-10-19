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
