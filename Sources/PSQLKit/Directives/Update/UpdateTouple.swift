import Foundation
import SQLKit

public struct UpdateTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: UpdateSQLExpression,
        T1: UpdateSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.updateSqlExpression,
            value.1.updateSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: UpdateSQLExpression,
        T1: UpdateSQLExpression,
        T2: UpdateSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.updateSqlExpression,
            value.1.updateSqlExpression,
            value.2.updateSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: UpdateSQLExpression,
        T1: UpdateSQLExpression,
        T2: UpdateSQLExpression,
        T3: UpdateSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.updateSqlExpression,
            value.1.updateSqlExpression,
            value.2.updateSqlExpression,
            value.3.updateSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: UpdateSQLExpression,
        T1: UpdateSQLExpression,
        T2: UpdateSQLExpression,
        T3: UpdateSQLExpression,
        T4: UpdateSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.updateSqlExpression,
            value.1.updateSqlExpression,
            value.2.updateSqlExpression,
            value.3.updateSqlExpression,
            value.4.updateSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5>(_ value: (T0, T1, T2, T3, T4, T5)) where
        T0: UpdateSQLExpression,
        T1: UpdateSQLExpression,
        T2: UpdateSQLExpression,
        T3: UpdateSQLExpression,
        T4: UpdateSQLExpression,
        T5: UpdateSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.updateSqlExpression,
            value.1.updateSqlExpression,
            value.2.updateSqlExpression,
            value.3.updateSqlExpression,
            value.4.updateSqlExpression,
            value.5.updateSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6>(_ value: (T0, T1, T2, T3, T4, T5, T6)) where
        T0: UpdateSQLExpression,
        T1: UpdateSQLExpression,
        T2: UpdateSQLExpression,
        T3: UpdateSQLExpression,
        T4: UpdateSQLExpression,
        T5: UpdateSQLExpression,
        T6: UpdateSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.updateSqlExpression,
            value.1.updateSqlExpression,
            value.2.updateSqlExpression,
            value.3.updateSqlExpression,
            value.4.updateSqlExpression,
            value.5.updateSqlExpression,
            value.6.updateSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7)) where
        T0: UpdateSQLExpression,
        T1: UpdateSQLExpression,
        T2: UpdateSQLExpression,
        T3: UpdateSQLExpression,
        T4: UpdateSQLExpression,
        T5: UpdateSQLExpression,
        T6: UpdateSQLExpression,
        T7: UpdateSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.updateSqlExpression,
            value.1.updateSqlExpression,
            value.2.updateSqlExpression,
            value.3.updateSqlExpression,
            value.4.updateSqlExpression,
            value.5.updateSqlExpression,
            value.6.updateSqlExpression,
            value.7.updateSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8)) where
        T0: UpdateSQLExpression,
        T1: UpdateSQLExpression,
        T2: UpdateSQLExpression,
        T3: UpdateSQLExpression,
        T4: UpdateSQLExpression,
        T5: UpdateSQLExpression,
        T6: UpdateSQLExpression,
        T7: UpdateSQLExpression,
        T8: UpdateSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.updateSqlExpression,
            value.1.updateSqlExpression,
            value.2.updateSqlExpression,
            value.3.updateSqlExpression,
            value.4.updateSqlExpression,
            value.5.updateSqlExpression,
            value.6.updateSqlExpression,
            value.7.updateSqlExpression,
            value.8.updateSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) where
        T0: UpdateSQLExpression,
        T1: UpdateSQLExpression,
        T2: UpdateSQLExpression,
        T3: UpdateSQLExpression,
        T4: UpdateSQLExpression,
        T5: UpdateSQLExpression,
        T6: UpdateSQLExpression,
        T7: UpdateSQLExpression,
        T8: UpdateSQLExpression,
        T9: UpdateSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.updateSqlExpression,
            value.1.updateSqlExpression,
            value.2.updateSqlExpression,
            value.3.updateSqlExpression,
            value.4.updateSqlExpression,
            value.5.updateSqlExpression,
            value.6.updateSqlExpression,
            value.7.updateSqlExpression,
            value.8.updateSqlExpression,
            value.9.updateSqlExpression
        ]
    }
}

extension UpdateTouple: UpdateSQLExpression {
    public var updateSqlExpression: some SQLExpression {
        SQLList(expressions)
    }
}
