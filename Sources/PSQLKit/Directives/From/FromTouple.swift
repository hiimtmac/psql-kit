import Foundation
import SQLKit

public struct FromTouple<T> {
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
    
    init<T0, T1, T2, T3, T4, T5>(_ value: (T0, T1, T2, T3, T4, T5)) where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible,
        T2: FromSQLExpressible,
        T3: FromSQLExpressible,
        T4: FromSQLExpressible,
        T5: FromSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.fromSqlExpression,
            value.1.fromSqlExpression,
            value.2.fromSqlExpression,
            value.3.fromSqlExpression,
            value.4.fromSqlExpression,
            value.5.fromSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6>(_ value: (T0, T1, T2, T3, T4, T5, T6)) where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible,
        T2: FromSQLExpressible,
        T3: FromSQLExpressible,
        T4: FromSQLExpressible,
        T5: FromSQLExpressible,
        T6: FromSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.fromSqlExpression,
            value.1.fromSqlExpression,
            value.2.fromSqlExpression,
            value.3.fromSqlExpression,
            value.4.fromSqlExpression,
            value.5.fromSqlExpression,
            value.6.fromSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7)) where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible,
        T2: FromSQLExpressible,
        T3: FromSQLExpressible,
        T4: FromSQLExpressible,
        T5: FromSQLExpressible,
        T6: FromSQLExpressible,
        T7: FromSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.fromSqlExpression,
            value.1.fromSqlExpression,
            value.2.fromSqlExpression,
            value.3.fromSqlExpression,
            value.4.fromSqlExpression,
            value.5.fromSqlExpression,
            value.6.fromSqlExpression,
            value.7.fromSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8)) where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible,
        T2: FromSQLExpressible,
        T3: FromSQLExpressible,
        T4: FromSQLExpressible,
        T5: FromSQLExpressible,
        T6: FromSQLExpressible,
        T7: FromSQLExpressible,
        T8: FromSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.fromSqlExpression,
            value.1.fromSqlExpression,
            value.2.fromSqlExpression,
            value.3.fromSqlExpression,
            value.4.fromSqlExpression,
            value.5.fromSqlExpression,
            value.6.fromSqlExpression,
            value.7.fromSqlExpression,
            value.8.fromSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) where
        T0: FromSQLExpressible,
        T1: FromSQLExpressible,
        T2: FromSQLExpressible,
        T3: FromSQLExpressible,
        T4: FromSQLExpressible,
        T5: FromSQLExpressible,
        T6: FromSQLExpressible,
        T7: FromSQLExpressible,
        T8: FromSQLExpressible,
        T9: FromSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.fromSqlExpression,
            value.1.fromSqlExpression,
            value.2.fromSqlExpression,
            value.3.fromSqlExpression,
            value.4.fromSqlExpression,
            value.5.fromSqlExpression,
            value.6.fromSqlExpression,
            value.7.fromSqlExpression,
            value.8.fromSqlExpression,
            value.9.fromSqlExpression
        ]
    }
}

extension FromTouple: FromSQLExpressible {
    public var fromSqlExpression: some SQLExpression {
        _From(expressions: expressions)
    }
    
    private struct _From: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions).serialize(to: &serializer)
        }
    }
}
