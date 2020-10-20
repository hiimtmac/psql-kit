import Foundation
import SQLKit

public struct CountExpression<Content>: SQLExpression where Content: SelectSQLExpressible {
    let content: Content
    
    public init(_ content: Content) {
        self.content = content
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("COUNT")
        serializer.write("(")
        content.selectSqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension CountExpression: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension CountExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<CountExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
