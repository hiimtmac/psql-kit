import Foundation
import SQLKit

struct FromTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.fromSqlExpression,
            value.1.fromSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible,
        T2: FromSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.fromSqlExpression,
            value.1.fromSqlExpression,
            value.2.fromSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible,
        T2: FromSQLExpressible,
        T3: FromSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.fromSqlExpression,
            value.1.fromSqlExpression,
            value.2.fromSqlExpression,
            value.3.fromSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible,
        T2: FromSQLExpressible,
        T3: FromSQLExpressible,
        T4: FromSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.fromSqlExpression,
            value.1.fromSqlExpression,
            value.2.fromSqlExpression,
            value.3.fromSqlExpression,
            value.4.fromSqlExpression
        ]
    }
}

extension FromTouple: FromSQLExpressible {
    var fromSqlExpression: From {
        .init(expressions: expressions)
    }
    
    struct From: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions).serialize(to: &serializer)
        }
    }
}
