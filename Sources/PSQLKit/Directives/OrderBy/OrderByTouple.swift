import Foundation
import SQLKit

public struct OrderByTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: OrderBySQLExpression,
        T1: OrderBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.orderBySqlExpression,
            value.1.orderBySqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: OrderBySQLExpression,
        T1: OrderBySQLExpression,
        T2: OrderBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.orderBySqlExpression,
            value.1.orderBySqlExpression,
            value.2.orderBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: OrderBySQLExpression,
        T1: OrderBySQLExpression,
        T2: OrderBySQLExpression,
        T3: OrderBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.orderBySqlExpression,
            value.1.orderBySqlExpression,
            value.2.orderBySqlExpression,
            value.3.orderBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: OrderBySQLExpression,
        T1: OrderBySQLExpression,
        T2: OrderBySQLExpression,
        T3: OrderBySQLExpression,
        T4: OrderBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.orderBySqlExpression,
            value.1.orderBySqlExpression,
            value.2.orderBySqlExpression,
            value.3.orderBySqlExpression,
            value.4.orderBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5>(_ value: (T0, T1, T2, T3, T4, T5)) where
        T0: OrderBySQLExpression,
        T1: OrderBySQLExpression,
        T2: OrderBySQLExpression,
        T3: OrderBySQLExpression,
        T4: OrderBySQLExpression,
        T5: OrderBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.orderBySqlExpression,
            value.1.orderBySqlExpression,
            value.2.orderBySqlExpression,
            value.3.orderBySqlExpression,
            value.4.orderBySqlExpression,
            value.5.orderBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6>(_ value: (T0, T1, T2, T3, T4, T5, T6)) where
        T0: OrderBySQLExpression,
        T1: OrderBySQLExpression,
        T2: OrderBySQLExpression,
        T3: OrderBySQLExpression,
        T4: OrderBySQLExpression,
        T5: OrderBySQLExpression,
        T6: OrderBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.orderBySqlExpression,
            value.1.orderBySqlExpression,
            value.2.orderBySqlExpression,
            value.3.orderBySqlExpression,
            value.4.orderBySqlExpression,
            value.5.orderBySqlExpression,
            value.6.orderBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7)) where
        T0: OrderBySQLExpression,
        T1: OrderBySQLExpression,
        T2: OrderBySQLExpression,
        T3: OrderBySQLExpression,
        T4: OrderBySQLExpression,
        T5: OrderBySQLExpression,
        T6: OrderBySQLExpression,
        T7: OrderBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.orderBySqlExpression,
            value.1.orderBySqlExpression,
            value.2.orderBySqlExpression,
            value.3.orderBySqlExpression,
            value.4.orderBySqlExpression,
            value.5.orderBySqlExpression,
            value.6.orderBySqlExpression,
            value.7.orderBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8)) where
        T0: OrderBySQLExpression,
        T1: OrderBySQLExpression,
        T2: OrderBySQLExpression,
        T3: OrderBySQLExpression,
        T4: OrderBySQLExpression,
        T5: OrderBySQLExpression,
        T6: OrderBySQLExpression,
        T7: OrderBySQLExpression,
        T8: OrderBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.orderBySqlExpression,
            value.1.orderBySqlExpression,
            value.2.orderBySqlExpression,
            value.3.orderBySqlExpression,
            value.4.orderBySqlExpression,
            value.5.orderBySqlExpression,
            value.6.orderBySqlExpression,
            value.7.orderBySqlExpression,
            value.8.orderBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) where
        T0: OrderBySQLExpression,
        T1: OrderBySQLExpression,
        T2: OrderBySQLExpression,
        T3: OrderBySQLExpression,
        T4: OrderBySQLExpression,
        T5: OrderBySQLExpression,
        T6: OrderBySQLExpression,
        T7: OrderBySQLExpression,
        T8: OrderBySQLExpression,
        T9: OrderBySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.orderBySqlExpression,
            value.1.orderBySqlExpression,
            value.2.orderBySqlExpression,
            value.3.orderBySqlExpression,
            value.4.orderBySqlExpression,
            value.5.orderBySqlExpression,
            value.6.orderBySqlExpression,
            value.7.orderBySqlExpression,
            value.8.orderBySqlExpression,
            value.9.orderBySqlExpression
        ]
    }
}

extension OrderByTouple: OrderBySQLExpression {
    public var orderBySqlExpression: some SQLExpression {
        SQLList(expressions)
    }
}
