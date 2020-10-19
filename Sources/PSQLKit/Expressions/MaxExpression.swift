import Foundation
import SQLKit

public struct MaxExpression<Content>: SQLExpression where Content: SelectSQLExpressible {
    let content: Content
    
    public init(_ content: Content) {
        self.content = content
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("MAX")
        serializer.write("(")
        content.selectSqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension MaxExpression: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension MaxExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<MaxExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
