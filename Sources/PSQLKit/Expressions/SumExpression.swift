import Foundation
import SQLKit

public struct SumExpression<Content>: AggregateExpression {
    let content: Content
    
    public init(_ content: Content) {
        self.content = content
    }
}

extension SumExpression: SelectSQLExpressible where Content: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content)
    }
    
    private struct _Select: SQLExpression {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("SUM")
            serializer.write("(")
            content.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension SumExpression: CompareSQLExpressible where Content: CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: content)
    }
    
    private struct _Compare: SQLExpression {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("SUM")
            serializer.write("(")
            content.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension SumExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = Content.CompareType
}

extension SumExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<SumExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
