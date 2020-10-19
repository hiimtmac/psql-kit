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
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write(rawValue)
    }
}

struct CompareExpression<T, U>: CompareSQLExpressible where T: CompareSQLExpressible, U: CompareSQLExpressible {
    let lhs: T
    let `operator`: CompareOperator
    let rhs: U
    
    struct Compare: SQLExpression {
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
    
    var compareSqlExpression: Compare {
        .init(lhs: lhs, operator: `operator`, rhs: rhs)
    }
}

extension CompareExpression: WhereSQLExpressible {
    typealias Where = Compare
    
    var whereSqlExpression: Where {
        .init(lhs: lhs, operator: `operator`, rhs: rhs)
    }
}
