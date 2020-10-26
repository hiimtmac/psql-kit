import Foundation
import SQLKit

public struct WhereTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.whereSqlExpression,
            value.1.whereSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: WhereSQLExpression,
        T1: WhereSQLExpression,
        T2: WhereSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.whereSqlExpression,
            value.1.whereSqlExpression,
            value.2.whereSqlExpression
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
            value.0.whereSqlExpression,
            value.1.whereSqlExpression,
            value.2.whereSqlExpression,
            value.3.whereSqlExpression
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
            value.0.whereSqlExpression,
            value.1.whereSqlExpression,
            value.2.whereSqlExpression,
            value.3.whereSqlExpression,
            value.4.whereSqlExpression
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
            value.0.whereSqlExpression,
            value.1.whereSqlExpression,
            value.2.whereSqlExpression,
            value.3.whereSqlExpression,
            value.4.whereSqlExpression,
            value.5.whereSqlExpression
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
            value.0.whereSqlExpression,
            value.1.whereSqlExpression,
            value.2.whereSqlExpression,
            value.3.whereSqlExpression,
            value.4.whereSqlExpression,
            value.5.whereSqlExpression,
            value.6.whereSqlExpression
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
            value.0.whereSqlExpression,
            value.1.whereSqlExpression,
            value.2.whereSqlExpression,
            value.3.whereSqlExpression,
            value.4.whereSqlExpression,
            value.5.whereSqlExpression,
            value.6.whereSqlExpression,
            value.7.whereSqlExpression
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
            value.0.whereSqlExpression,
            value.1.whereSqlExpression,
            value.2.whereSqlExpression,
            value.3.whereSqlExpression,
            value.4.whereSqlExpression,
            value.5.whereSqlExpression,
            value.6.whereSqlExpression,
            value.7.whereSqlExpression,
            value.8.whereSqlExpression
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
            value.0.whereSqlExpression,
            value.1.whereSqlExpression,
            value.2.whereSqlExpression,
            value.3.whereSqlExpression,
            value.4.whereSqlExpression,
            value.5.whereSqlExpression,
            value.6.whereSqlExpression,
            value.7.whereSqlExpression,
            value.8.whereSqlExpression,
            value.9.whereSqlExpression
        ]
    }
}

extension WhereTouple: WhereSQLExpression {
    public var whereSqlExpression: some SQLExpression {
        SQLList(expressions, separator: SQLRaw(" AND "))
    }
}
