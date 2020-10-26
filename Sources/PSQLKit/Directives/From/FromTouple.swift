import Foundation
import SQLKit

public struct FromTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: FromSQLExpression,
        T1: FromSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.fromSqlExpression,
            value.1.fromSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: FromSQLExpression,
        T1: FromSQLExpression,
        T2: FromSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.fromSqlExpression,
            value.1.fromSqlExpression,
            value.2.fromSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: FromSQLExpression,
        T1: FromSQLExpression,
        T2: FromSQLExpression,
        T3: FromSQLExpression
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
        T0: FromSQLExpression,
        T1: FromSQLExpression,
        T2: FromSQLExpression,
        T3: FromSQLExpression,
        T4: FromSQLExpression
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
        T0: FromSQLExpression,
        T1: FromSQLExpression,
        T2: FromSQLExpression,
        T3: FromSQLExpression,
        T4: FromSQLExpression,
        T5: FromSQLExpression
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
        T0: FromSQLExpression,
        T1: FromSQLExpression,
        T2: FromSQLExpression,
        T3: FromSQLExpression,
        T4: FromSQLExpression,
        T5: FromSQLExpression,
        T6: FromSQLExpression
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
        T0: FromSQLExpression,
        T1: FromSQLExpression,
        T2: FromSQLExpression,
        T3: FromSQLExpression,
        T4: FromSQLExpression,
        T5: FromSQLExpression,
        T6: FromSQLExpression,
        T7: FromSQLExpression
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
        T0: FromSQLExpression,
        T1: FromSQLExpression,
        T2: FromSQLExpression,
        T3: FromSQLExpression,
        T4: FromSQLExpression,
        T5: FromSQLExpression,
        T6: FromSQLExpression,
        T7: FromSQLExpression,
        T8: FromSQLExpression
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
        T0: FromSQLExpression,
        T1: FromSQLExpression,
        T2: FromSQLExpression,
        T3: FromSQLExpression,
        T4: FromSQLExpression,
        T5: FromSQLExpression,
        T6: FromSQLExpression,
        T7: FromSQLExpression,
        T8: FromSQLExpression,
        T9: FromSQLExpression
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

extension FromTouple: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression {
        SQLList(expressions)
    }
}
