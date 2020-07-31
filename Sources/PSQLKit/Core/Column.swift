import Foundation

@propertyWrapper
struct ColumnProperty<Model: Table, Value: PSQLable> {
    let key: String
    
    init(key: String) {
        self.key = key
    }
    
    var projectedValue: Self { self }
    
    var wrappedValue: Value {
        fatalError("Not to be accessed. Query only")
    }
}
