import Foundation
import SQLKit

struct MinExpression<Content>: SQLExpression where Content: SelectSQLExpressible {
    let content: Content
    
    init(_ content: Content) {
        self.content = content
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("MIN")
        serializer.write("(")
        content.selectSqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension MinExpression: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

extension MinExpression {
    func `as`(_ alias: String) -> ExpressionAlias<MinExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
