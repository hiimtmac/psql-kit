import Foundation
import SQLKit

struct MaxExpression<Content>: SQLExpression where Content: SelectSQLExpressible {
    let content: Content
    
    init(_ content: Content) {
        self.content = content
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("MAX")
        serializer.write("(")
        content.selectSqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension MaxExpression: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

extension MaxExpression {
    func `as`(_ alias: String) -> ExpressionAlias<MaxExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
