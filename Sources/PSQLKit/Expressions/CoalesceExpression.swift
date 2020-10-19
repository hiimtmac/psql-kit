import Foundation
import SQLKit

public struct CoalesceExpression<Content, Default>: SQLExpression where Content: SelectSQLExpressible & TypeEquatable, Default: SelectSQLExpressible & TypeEquatable, Content.CompareType == Default.CompareType {
    let content: Content
    let `default`: Default
    
    public init(_ content: Content, _ default: Default) {
        self.content = content
        self.default = `default`
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
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
    public typealias CompareType = Content.CompareType
}

extension CoalesceExpression: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension CoalesceExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<CoalesceExpression<Content, Default>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
