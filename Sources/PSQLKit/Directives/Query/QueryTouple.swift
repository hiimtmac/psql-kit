import Foundation
import SQLKit

public struct QueryTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: QuerySQLExpression,
        T1: QuerySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression,
            value.2.querySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression,
            value.2.querySqlExpression,
            value.3.querySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression,
        T4: QuerySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression,
            value.2.querySqlExpression,
            value.3.querySqlExpression,
            value.4.querySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5>(_ value: (T0, T1, T2, T3, T4, T5)) where
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression,
        T4: QuerySQLExpression,
        T5: QuerySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression,
            value.2.querySqlExpression,
            value.3.querySqlExpression,
            value.4.querySqlExpression,
            value.5.querySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6>(_ value: (T0, T1, T2, T3, T4, T5, T6)) where
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression,
        T4: QuerySQLExpression,
        T5: QuerySQLExpression,
        T6: QuerySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression,
            value.2.querySqlExpression,
            value.3.querySqlExpression,
            value.4.querySqlExpression,
            value.5.querySqlExpression,
            value.6.querySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7)) where
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression,
        T4: QuerySQLExpression,
        T5: QuerySQLExpression,
        T6: QuerySQLExpression,
        T7: QuerySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression,
            value.2.querySqlExpression,
            value.3.querySqlExpression,
            value.4.querySqlExpression,
            value.5.querySqlExpression,
            value.6.querySqlExpression,
            value.7.querySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8)) where
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression,
        T4: QuerySQLExpression,
        T5: QuerySQLExpression,
        T6: QuerySQLExpression,
        T7: QuerySQLExpression,
        T8: QuerySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression,
            value.2.querySqlExpression,
            value.3.querySqlExpression,
            value.4.querySqlExpression,
            value.5.querySqlExpression,
            value.6.querySqlExpression,
            value.7.querySqlExpression,
            value.8.querySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) where
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression,
        T4: QuerySQLExpression,
        T5: QuerySQLExpression,
        T6: QuerySQLExpression,
        T7: QuerySQLExpression,
        T8: QuerySQLExpression,
        T9: QuerySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.querySqlExpression,
            value.1.querySqlExpression,
            value.2.querySqlExpression,
            value.3.querySqlExpression,
            value.4.querySqlExpression,
            value.5.querySqlExpression,
            value.6.querySqlExpression,
            value.7.querySqlExpression,
            value.8.querySqlExpression,
            value.9.querySqlExpression
        ]
    }
}

extension QueryTouple: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression {
        SQLList(expressions, separator: SQLRaw(" "))
    }
}
