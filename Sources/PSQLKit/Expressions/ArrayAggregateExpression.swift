import Foundation
import SQLKit

public struct ArrayAggregateExpression<Content>: AggregateExpression {
    let content: Content
    
    public init(_ content: Content) {
        self.content = content
    }
}

extension ArrayAggregateExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: SQLExpression {
        _Select(content: content)
    }
    
    private struct _Select: SQLExpression {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_AGG")
            serializer.write("(")
            content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayAggregateExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: SQLExpression {
        _Compare(content: content)
    }
    
    private struct _Compare: SQLExpression {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_AGG")
            serializer.write("(")
            content.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayAggregateExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = [Content.CompareType]
}

extension ArrayAggregateExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayAggregateExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
