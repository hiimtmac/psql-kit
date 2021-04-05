import Foundation
import SQLKit

public struct WhereTouple<T> {
    let value: T
    let expressions: [WhereSQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1,
            value.2
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression
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
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression,
        T4: WhereSQLExpression
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
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression,
        T4: WhereSQLExpression,
        T5: WhereSQLExpression
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
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression,
        T4: WhereSQLExpression,
        T5: WhereSQLExpression,
        T6: WhereSQLExpression
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
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression,
        T4: WhereSQLExpression,
        T5: WhereSQLExpression,
        T6: WhereSQLExpression,
        T7: WhereSQLExpression
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
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression,
        T4: WhereSQLExpression,
        T5: WhereSQLExpression,
        T6: WhereSQLExpression,
        T7: WhereSQLExpression,
        T8: WhereSQLExpression
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
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression,
        T3: WhereSQLExpression,
        T4: WhereSQLExpression,
        T5: WhereSQLExpression,
        T6: WhereSQLExpression,
        T7: WhereSQLExpression,
        T8: WhereSQLExpression,
        T9: WhereSQLExpression
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

extension WhereTouple: WhereSQLExpression {
    public var whereSqlExpression: SQLExpression {
        SQLList(expressions.map(\.whereSqlExpression), separator: SQLRaw(" AND "))
    }
}
