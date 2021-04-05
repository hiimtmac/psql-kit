import Foundation
import SQLKit

public struct UpdateTouple<T> {
    let value: T
    let expressions: [UpdateSQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: UpdateSQLExpression,
        T1: UpdateSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: UpdateSQLExpression,
        T1: UpdateSQLExpression,
        T2: UpdateSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1,
            value.2
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
            value.0,
            value.1,
            value.2,
            value.3
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
            value.0,
            value.1,
            value.2,
            value.3,
            value.4
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
            value.0,
            value.1,
            value.2,
            value.3,
            value.4,
            value.5
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
            value.0,
            value.1,
            value.2,
            value.3,
            value.4,
            value.5,
            value.6
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
            value.0,
            value.1,
            value.2,
            value.3,
            value.4,
            value.5,
            value.6,
            value.7
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
            value.0,
            value.1,
            value.2,
            value.3,
            value.4,
            value.5,
            value.6,
            value.7,
            value.8
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
            value.0,
            value.1,
            value.2,
            value.3,
            value.4,
            value.5,
            value.6,
            value.7,
            value.8,
            value.9
        ]
    }
}

extension UpdateTouple: UpdateSQLExpression {
    public var updateSqlExpression: SQLExpression {
        SQLList(expressions.map(\.updateSqlExpression))
    }
}
