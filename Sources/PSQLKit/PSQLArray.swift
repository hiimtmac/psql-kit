import Foundation
import PostgresKit

public protocol PSQLArrayRepresentable {}

public struct PSQLArray<T>: PSQLArrayRepresentable where
    T: PSQLExpression
{
    let items: [T]
    
    public init(_ items: [T]) {
        self.items = items
    }
}

extension PSQLArray: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension PSQLArray: SelectSQLExpression where
    T: SQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(items: items, arrayType: [T].postgresColumnType)
    }
    
    private struct _Select: SQLExpression {
        let items: [T]
        let arrayType: SQLExpression
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY")
            serializer.write("[")
            SQLList(items).serialize(to: &serializer)
            serializer.write("]")
            serializer.write("::")
            arrayType.serialize(to: &serializer)
        }
    }
}

extension PSQLArray: CompareSQLExpression where
    T: SQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(items: items)
    }
    
    private struct _Compare: SQLExpression {
        let items: [T]
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY")
            serializer.write("[")
            SQLList(items).serialize(to: &serializer)
            serializer.write("]")
        }
    }
}
