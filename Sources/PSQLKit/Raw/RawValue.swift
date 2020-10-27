import Foundation
import SQLKit

public struct RawValue<T> where T: PSQLExpression & SQLExpression {
    let value: T
    
    public init(_ value: T) {
        self.value = value
    }
}

extension RawValue {
    public func `as`(_ alias: String) -> RawValueAlias<T> {
        RawValueAlias(value: value, alias: alias)
    }
}

extension RawValue: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension RawValue: SelectSQLExpression {
    private struct _Select: SQLExpression {
        let value: T
        
        func serialize(to serializer: inout SQLSerializer) {
            value.serialize(to: &serializer)
            serializer.write("::")
            T.postgresColumnType.serialize(to: &serializer)
        }
    }
    
    public var selectSqlExpression: some SQLExpression {
        _Select(value: value)
    }
}
