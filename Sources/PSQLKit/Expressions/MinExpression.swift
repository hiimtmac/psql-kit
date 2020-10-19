import Foundation
import SQLKit

public struct MinExpression<Content>: SQLExpression where Content: SelectSQLExpressible {
    let content: Content
    
    public init(_ content: Content) {
        self.content = content
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("MIN")
        serializer.write("(")
        content.selectSqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension MinExpression: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension MinExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<MinExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
