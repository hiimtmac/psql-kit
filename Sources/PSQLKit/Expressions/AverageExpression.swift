import Foundation
import SQLKit

public struct AverageExpression<Content>: SQLExpression where Content: SelectSQLExpressible {
    let content: Content
    
    public init(_ content: Content) {
        self.content = content
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("AVG")
        serializer.write("(")
        content.selectSqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension AverageExpression: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension AverageExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<AverageExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
