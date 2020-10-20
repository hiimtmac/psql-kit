import Foundation
import SQLKit

public struct WithTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.withSqlExpression,
            value.1.withSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible,
        T2: WithSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.withSqlExpression,
            value.1.withSqlExpression,
            value.2.withSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible,
        T2: WithSQLExpressible,
        T3: WithSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.withSqlExpression,
            value.1.withSqlExpression,
            value.2.withSqlExpression,
            value.3.withSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible,
        T2: WithSQLExpressible,
        T3: WithSQLExpressible,
        T4: WithSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.withSqlExpression,
            value.1.withSqlExpression,
            value.2.withSqlExpression,
            value.3.withSqlExpression,
            value.4.withSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5>(_ value: (T0, T1, T2, T3, T4, T5)) where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible,
        T2: WithSQLExpressible,
        T3: WithSQLExpressible,
        T4: WithSQLExpressible,
        T5: WithSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.withSqlExpression,
            value.1.withSqlExpression,
            value.2.withSqlExpression,
            value.3.withSqlExpression,
            value.4.withSqlExpression,
            value.5.withSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6>(_ value: (T0, T1, T2, T3, T4, T5, T6)) where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible,
        T2: WithSQLExpressible,
        T3: WithSQLExpressible,
        T4: WithSQLExpressible,
        T5: WithSQLExpressible,
        T6: WithSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.withSqlExpression,
            value.1.withSqlExpression,
            value.2.withSqlExpression,
            value.3.withSqlExpression,
            value.4.withSqlExpression,
            value.5.withSqlExpression,
            value.6.withSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7)) where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible,
        T2: WithSQLExpressible,
        T3: WithSQLExpressible,
        T4: WithSQLExpressible,
        T5: WithSQLExpressible,
        T6: WithSQLExpressible,
        T7: WithSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.withSqlExpression,
            value.1.withSqlExpression,
            value.2.withSqlExpression,
            value.3.withSqlExpression,
            value.4.withSqlExpression,
            value.5.withSqlExpression,
            value.6.withSqlExpression,
            value.7.withSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8)) where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible,
        T2: WithSQLExpressible,
        T3: WithSQLExpressible,
        T4: WithSQLExpressible,
        T5: WithSQLExpressible,
        T6: WithSQLExpressible,
        T7: WithSQLExpressible,
        T8: WithSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.withSqlExpression,
            value.1.withSqlExpression,
            value.2.withSqlExpression,
            value.3.withSqlExpression,
            value.4.withSqlExpression,
            value.5.withSqlExpression,
            value.6.withSqlExpression,
            value.7.withSqlExpression,
            value.8.withSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) where
        T0: WithSQLExpressible,
        T1: WithSQLExpressible,
        T2: WithSQLExpressible,
        T3: WithSQLExpressible,
        T4: WithSQLExpressible,
        T5: WithSQLExpressible,
        T6: WithSQLExpressible,
        T7: WithSQLExpressible,
        T8: WithSQLExpressible,
        T9: WithSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.withSqlExpression,
            value.1.withSqlExpression,
            value.2.withSqlExpression,
            value.3.withSqlExpression,
            value.4.withSqlExpression,
            value.5.withSqlExpression,
            value.6.withSqlExpression,
            value.7.withSqlExpression,
            value.8.withSqlExpression,
            value.9.withSqlExpression
        ]
    }
}

extension WithTouple: WithSQLExpressible {
    public var withSqlExpression: some SQLExpression {
        _With(expressions: expressions)
    }
    
    private struct _With: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions).serialize(to: &serializer)
        }
    }
}
