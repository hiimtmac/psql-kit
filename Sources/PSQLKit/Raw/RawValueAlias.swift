import Foundation
import SQLKit
import PostgresKit

public struct RawValueAlias<T> where T: PSQLExpression & SQLExpression {
    let value: T
    let alias: String
    
    public init(value: T, alias: String) {
        self.value = value
        self.alias = alias
    }
}

extension RawValueAlias: SelectSQLExpression {
    private struct _Select: SQLExpression {
        let value: T
        let alias: String
        
        func serialize(to serializer: inout SQLSerializer) {
            value.serialize(to: &serializer)
            serializer.write("::")
            T.postgresColumnType.serialize(to: &serializer)
            
            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()
            
            serializer.writeQuote()
            serializer.write(alias)
            serializer.writeQuote()
        }
    }
    
    public var selectSqlExpression: some SQLExpression {
        _Select(value: value, alias: alias)
    }
}

extension RawValueAlias: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}
