import Foundation
import SQLKit

public struct JoinTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: JoinSQLExpression,
        T1: JoinSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: JoinSQLExpression,
        T1: JoinSQLExpression,
        T2: JoinSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: JoinSQLExpression,
        T1: JoinSQLExpression,
        T2: JoinSQLExpression,
        T3: JoinSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: JoinSQLExpression,
        T1: JoinSQLExpression,
        T2: JoinSQLExpression,
        T3: JoinSQLExpression,
        T4: JoinSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression,
            value.4.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5>(_ value: (T0, T1, T2, T3, T4, T5)) where
        T0: JoinSQLExpression,
        T1: JoinSQLExpression,
        T2: JoinSQLExpression,
        T3: JoinSQLExpression,
        T4: JoinSQLExpression,
        T5: JoinSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression,
            value.4.joinSqlExpression,
            value.5.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6>(_ value: (T0, T1, T2, T3, T4, T5, T6)) where
        T0: JoinSQLExpression,
        T1: JoinSQLExpression,
        T2: JoinSQLExpression,
        T3: JoinSQLExpression,
        T4: JoinSQLExpression,
        T5: JoinSQLExpression,
        T6: JoinSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression,
            value.4.joinSqlExpression,
            value.5.joinSqlExpression,
            value.6.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7)) where
        T0: JoinSQLExpression,
        T1: JoinSQLExpression,
        T2: JoinSQLExpression,
        T3: JoinSQLExpression,
        T4: JoinSQLExpression,
        T5: JoinSQLExpression,
        T6: JoinSQLExpression,
        T7: JoinSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression,
            value.4.joinSqlExpression,
            value.5.joinSqlExpression,
            value.6.joinSqlExpression,
            value.7.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8)) where
        T0: JoinSQLExpression,
        T1: JoinSQLExpression,
        T2: JoinSQLExpression,
        T3: JoinSQLExpression,
        T4: JoinSQLExpression,
        T5: JoinSQLExpression,
        T6: JoinSQLExpression,
        T7: JoinSQLExpression,
        T8: JoinSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression,
            value.4.joinSqlExpression,
            value.5.joinSqlExpression,
            value.6.joinSqlExpression,
            value.7.joinSqlExpression,
            value.8.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) where
        T0: JoinSQLExpression,
        T1: JoinSQLExpression,
        T2: JoinSQLExpression,
        T3: JoinSQLExpression,
        T4: JoinSQLExpression,
        T5: JoinSQLExpression,
        T6: JoinSQLExpression,
        T7: JoinSQLExpression,
        T8: JoinSQLExpression,
        T9: JoinSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression,
            value.4.joinSqlExpression,
            value.5.joinSqlExpression,
            value.6.joinSqlExpression,
            value.7.joinSqlExpression,
            value.8.joinSqlExpression,
            value.9.joinSqlExpression
        ]
    }
}

extension JoinTouple: JoinSQLExpression {
    public var joinSqlExpression: some SQLExpression {
        SQLList(expressions, separator: SQLRaw(" AND "))
    }
}
