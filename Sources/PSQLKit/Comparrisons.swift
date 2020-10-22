import Foundation
import SQLKit

enum CompareOperator: String, SQLExpression {
    case equal = "="
    case notEqual = "!="
    case `in` = "IN"
    case notIn = "NOT IN"
    case lessThan = "<"
    case lessThanOrEqual = "<="
    case greaterThan = ">"
    case greaterThanOrEqual = ">="
    case between = "BETWEEN"
    case notBetween = "NOT BETWEEN"
    case or = "OR"
    case like = "LIKE"
    case notLike = "NOT LIKE"
    case iLike = "ILIKE"
    case notILike = "NOT ILIKE"
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write(rawValue)
    }
}

public struct CompareExpression<T, U> where T: CompareSQLExpressible, U: CompareSQLExpressible {
    let lhs: T
    let `operator`: CompareOperator
    let rhs: U
}

extension CompareExpression: TypeEquatable {
    public typealias CompareType = Any
}

extension CompareExpression: CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression {
        _Compare(lhs: lhs, operator: `operator`, rhs: rhs)
    }
    
    private struct _Compare: SQLExpression {
        let lhs: T
        let `operator`: CompareOperator
        let rhs: U
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("(")
            lhs.compareSqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            `operator`.serialize(to: &serializer)
            serializer.writeSpace()
            rhs.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension CompareExpression: WhereSQLExpressible {
    public var whereSqlExpression: some SQLExpression {
        _Compare(lhs: lhs, operator: `operator`, rhs: rhs)
    }
}

extension CompareExpression: HavingSQLExpressible {
    public var havingSqlExpression: some SQLExpression {
        _Compare(lhs: lhs, operator: `operator`, rhs: rhs)
    }
}

extension CompareExpression: JoinSQLExpressible {
    public var joinSqlExpression: some SQLExpression {
        _Compare(lhs: lhs, operator: `operator`, rhs: rhs)
    }
}
