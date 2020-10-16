import Foundation
import SQLKit

struct WhereTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.whereSqlExpression,
            value.1.whereSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.whereSqlExpression,
            value.1.whereSqlExpression,
            value.2.whereSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible,
        T3: WhereSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.whereSqlExpression,
            value.1.whereSqlExpression,
            value.2.whereSqlExpression,
            value.3.whereSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible,
        T3: WhereSQLExpressible,
        T4: WhereSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.whereSqlExpression,
            value.1.whereSqlExpression,
            value.2.whereSqlExpression,
            value.3.whereSqlExpression,
            value.4.whereSqlExpression
        ]
    }
}

extension WhereTouple: WhereSQLExpressible {
    var whereSqlExpression: Where {
        .init(expressions: expressions)
    }
    
    struct Where: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions).serialize(to: &serializer)
        }
    }
}
