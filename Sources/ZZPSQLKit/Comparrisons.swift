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
    struct Where: SQLExpression {
        let compare: Compare
        
        func serialize(to serializer: inout SQLSerializer) {
            compare.serialize(to: &serializer)
        }
    }
    
    var whereSqlExpression: Where {
        .init(compare: compareSqlExpression)
    }
}

extension Array: CompareSQLExpressible where Element: PKExpressible {
    struct Compare: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("(")
            SQLList(expressions).serialize(to: &serializer)
            serializer.write(")")
        }
    }
    
    var compareSqlExpression: Compare {
        .init(expressions: self)
    }
}
