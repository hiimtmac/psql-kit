import Foundation
import SQLKit

struct QueryTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible,
        T2: QuerySQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression,
            value.2.querySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible,
        T2: QuerySQLExpressible,
        T3: QuerySQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression,
            value.2.querySqlExpression,
            value.3.querySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: QuerySQLExpressible,
        T1: QuerySQLExpressible,
        T2: QuerySQLExpressible,
        T3: QuerySQLExpressible,
        T4: QuerySQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression,
            value.2.querySqlExpression,
            value.3.querySqlExpression,
            value.4.querySqlExpression
        ]
    }
}

extension QueryTouple: QuerySQLExpressible {
    var querySqlExpression: Query {
        .init(expressions: expressions)
    }
    
    struct Query: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions, separator: SQLRaw(" ")).serialize(to: &serializer)
        }
    }
}
