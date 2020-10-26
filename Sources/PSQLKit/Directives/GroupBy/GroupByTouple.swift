import Foundation
import SQLKit

public struct GroupByTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression,
            value.2.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression,
            value.2.groupBySqlExpression,
            value.3.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression,
        T4: GroupBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression,
            value.2.groupBySqlExpression,
            value.3.groupBySqlExpression,
            value.4.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5>(_ value: (T0, T1, T2, T3, T4, T5)) where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression,
        T4: GroupBySQLExpression,
        T5: GroupBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression,
            value.2.groupBySqlExpression,
            value.3.groupBySqlExpression,
            value.4.groupBySqlExpression,
            value.5.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6>(_ value: (T0, T1, T2, T3, T4, T5, T6)) where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression,
        T4: GroupBySQLExpression,
        T5: GroupBySQLExpression,
        T6: GroupBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression,
            value.2.groupBySqlExpression,
            value.3.groupBySqlExpression,
            value.4.groupBySqlExpression,
            value.5.groupBySqlExpression,
            value.6.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7)) where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression,
        T4: GroupBySQLExpression,
        T5: GroupBySQLExpression,
        T6: GroupBySQLExpression,
        T7: GroupBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression,
            value.2.groupBySqlExpression,
            value.3.groupBySqlExpression,
            value.4.groupBySqlExpression,
            value.5.groupBySqlExpression,
            value.6.groupBySqlExpression,
            value.7.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8)) where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression,
        T4: GroupBySQLExpression,
        T5: GroupBySQLExpression,
        T6: GroupBySQLExpression,
        T7: GroupBySQLExpression,
        T8: GroupBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression,
            value.2.groupBySqlExpression,
            value.3.groupBySqlExpression,
            value.4.groupBySqlExpression,
            value.5.groupBySqlExpression,
            value.6.groupBySqlExpression,
            value.7.groupBySqlExpression,
            value.8.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) where
        T0: GroupBySQLExpression,
        T1: GroupBySQLExpression,
        T2: GroupBySQLExpression,
        T3: GroupBySQLExpression,
        T4: GroupBySQLExpression,
        T5: GroupBySQLExpression,
        T6: GroupBySQLExpression,
        T7: GroupBySQLExpression,
        T8: GroupBySQLExpression,
        T9: GroupBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression,
            value.2.groupBySqlExpression,
            value.3.groupBySqlExpression,
            value.4.groupBySqlExpression,
            value.5.groupBySqlExpression,
            value.6.groupBySqlExpression,
            value.7.groupBySqlExpression,
            value.8.groupBySqlExpression,
            value.9.groupBySqlExpression
        ]
    }
}

extension GroupByTouple: GroupBySQLExpression {
    public var groupBySqlExpression: some SQLExpression {
        SQLList(expressions)
    }
}
