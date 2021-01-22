import Foundation
import SQLKit
import PostgresKit

public struct ArrayLengthExpression<Content>: AggregateExpression where
    Content: PSQLArrayRepresentable
{
    let content: Content
    let dimension: Int
    
    public init(_ content: Content, dimension: Int) {
        self.content = content
        self.dimension = dimension
    }
}

extension ArrayLengthExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content, dimension: dimension)
    }
    
    private struct _Select: SQLExpression {
        let content: Content
        let dimension: Int
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_LENGTH")
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

extension ArrayLengthExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: content, dimension: dimension)
    }
    
    private struct _Compare: SQLExpression {
        let content: Content
        let dimension: Int
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_LENGTH")
            serializer.write("(")
            content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            dimension.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayLengthExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Int
}

extension ArrayLengthExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayLengthExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
