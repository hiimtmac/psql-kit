import Foundation
import SQLKit

struct SumExpression<Content>: SQLExpression where Content: SelectSQLExpressible {
    let content: Content
    
    init(_ content: Content) {
        self.content = content
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("SUM")
        serializer.write("(")
        content.selectSqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension SumExpression: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

extension SumExpression {
    func `as`(_ alias: String) -> ExpressionAlias<SumExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
