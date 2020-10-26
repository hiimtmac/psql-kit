import Foundation
import SQLKit

public struct RawValue<T>: SQLExpression where T: PSQLExpression {
    let value: T
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        value.serialize(to: &serializer)
        serializer.write("::")
        T.postgresColumnType.serialize(to: &serializer)
    }
}
