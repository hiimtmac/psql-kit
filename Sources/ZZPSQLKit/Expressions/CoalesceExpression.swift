import Foundation
import SQLKit

struct CoalesceExpression<Content, Default>: SQLExpression where Content: SelectSQLExpressible & TypeEquatable, Default: SelectSQLExpressible & TypeEquatable, Content.CompareType == Default.CompareType {
    let content: Content
    let `default`: Default
    
    init(_ content: Content, _ default: Default) {
        self.content = content
        self.default = `default`
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("COALESCE")
        serializer.write("(")
        content.selectSqlExpression.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        `default`.selectSqlExpression.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension CoalesceExpression: TypeEquatable {
    typealias CompareType = Content.CompareType
}

extension CoalesceExpression: SelectSQLExpressible {
    var selectSqlExpression: Self { self }
}

extension CoalesceExpression {
    func `as`(_ alias: String) -> ExpressionAlias<CoalesceExpression<Content, Default>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
