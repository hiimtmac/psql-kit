import Foundation
import SQLKit

public struct ExpressionAlias<Expression> {
    let expression: Expression
    let alias: String
}

extension ExpressionAlias: TypeEquatable where Expression: TypeEquatable {
    public typealias CompareType = Expression.CompareType
}

extension ExpressionAlias: SelectSQLExpression where
    Expression: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(expression: expression, alias: alias)
    }
    
    private struct _Select: SQLExpression {
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
}

extension ExpressionAlias: FromSQLExpression where
    Expression: FromSQLExpression
{
    public var fromSqlExpression: some SQLExpression {
        _From(expression: expression, alias: alias)
    }
    
    private struct _From: SQLExpression {
        let expression: Expression
        let alias: String
        
        func serialize(to serializer: inout SQLSerializer) {
            expression.fromSqlExpression.serialize(to: &serializer)
            
            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()
            
            serializer.writeQuote()
            serializer.write(alias)
            serializer.writeQuote()
        }
    }
}
