import Foundation
import SQLKit

public struct ExpressionAlias<Expression>: SQLExpression where Expression: SelectSQLExpressible {
    let expression: Expression
    let alias: String
    
    public func serialize(to serializer: inout SQLSerializer) {
        expression.selectSqlExpression.serialize(to: &serializer)
        
        serializer.writeSpace()
        serializer.write("AS")
        serializer.writeSpace()
        
        serializer.writeQuote()
        serializer.write(alias)
        serializer.writeQuote()
    }
}

extension ExpressionAlias: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension ExpressionAlias: FromSQLExpressible {
    public var fromSqlExpression: some SQLExpression { self }
}
