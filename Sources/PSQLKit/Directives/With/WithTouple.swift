import Foundation
import SQLKit

public struct WithTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: WithSQLExpression,
        T1: WithSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.withSqlExpression,
            value.1.withSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.withSqlExpression,
            value.1.withSqlExpression,
            value.2.withSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression
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
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression,
        T4: WithSQLExpression
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
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression,
        T4: WithSQLExpression,
        T5: WithSQLExpression
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
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression,
        T4: WithSQLExpression,
        T5: WithSQLExpression,
        T6: WithSQLExpression
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
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression,
        T4: WithSQLExpression,
        T5: WithSQLExpression,
        T6: WithSQLExpression,
        T7: WithSQLExpression
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
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression,
        T4: WithSQLExpression,
        T5: WithSQLExpression,
        T6: WithSQLExpression,
        T7: WithSQLExpression,
        T8: WithSQLExpression
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
        T0: WithSQLExpression,
        T1: WithSQLExpression,
        T2: WithSQLExpression,
        T3: WithSQLExpression,
        T4: WithSQLExpression,
        T5: WithSQLExpression,
        T6: WithSQLExpression,
        T7: WithSQLExpression,
        T8: WithSQLExpression,
        T9: WithSQLExpression
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

extension WithTouple: WithSQLExpression {
    public var withSqlExpression: some SQLExpression {
        SQLList(expressions)
    }
}
