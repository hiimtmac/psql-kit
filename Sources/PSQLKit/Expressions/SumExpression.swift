import Foundation
import SQLKit

public struct SumExpression<Content>: SQLExpression where Content: SelectSQLExpressible {
    let content: Content
    
    public init(_ content: Content) {
        self.content = content
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("SUM")
        serializer.write("(")
        content.selectSqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension SumExpression: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension SumExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<SumExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
