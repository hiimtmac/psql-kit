import Foundation
import SQLKit
import PostgresKit

public struct ArrayLowerExpression<Content>: AggregateExpression where
    Content: PSQLArrayRepresentable
{
    let content: Content
    let dimension: Int
    
    public init(_ content: Content, dimension: Int) {
        self.content = content
        self.dimension = dimension
    }
}

extension ArrayLowerExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content, dimension: dimension)
    }
    
    private struct _Select: SQLExpression {
        let content: Content
        let dimension: Int
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_LOWER")
            serializer.write("(")
            content.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            dimension.serialize(to: &serializer)
            serializer.write(")")
            serializer.write("::")
            PostgresColumnType.integer.serialize(to: &serializer)
        }
    }
}

extension ArrayLowerExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: content, dimension: dimension)
    }
    
    private struct _Compare: SQLExpression {
        let content: Content
        let dimension: Int
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_LOWER")
            serializer.write("(")
            content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            dimension.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayLowerExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Int
}

extension ArrayLowerExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayLowerExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
