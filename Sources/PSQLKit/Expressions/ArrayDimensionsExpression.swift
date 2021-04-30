import Foundation
import SQLKit
import PostgresKit

public struct ArrayDimensionsExpression<Content>: AggregateExpression where
    Content: PSQLArrayRepresentable
{
    let content: Content
    
    public init(_ content: Content) {
        self.content = content
    }
}

extension ArrayDimensionsExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: SQLExpression {
        _Select(content: content)
    }
    
    private struct _Select: SQLExpression {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_DIMS")
            serializer.write("(")
            content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.write("::")
            PostgresColumnType.text.serialize(to: &serializer)
        }
    }
}

extension ArrayDimensionsExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: SQLExpression {
        _Compare(content: content)
    }
    
    private struct _Compare: SQLExpression {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_DIMS")
            serializer.write("(")
            content.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayDimensionsExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = String
}

extension ArrayDimensionsExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayDimensionsExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
