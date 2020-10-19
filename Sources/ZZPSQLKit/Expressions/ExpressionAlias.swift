import Foundation
import SQLKit

struct ExpressionAlias<Expression>: SQLExpression where Expression: SelectSQLExpressible {
    let expression: Expression
    let alias: String
    
    func serialize(to serializer: inout SQLSerializer) {
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
    var selectSqlExpression: Self { self }
}

extension ExpressionAlias: FromSQLExpressible {
    var fromSqlExpression: Self { self }
}
