import Foundation
import SQLKit

public struct OrderByTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.orderBySqlExpression,
            value.1.orderBySqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible,
        T2: OrderBySQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.orderBySqlExpression,
            value.1.orderBySqlExpression,
            value.2.orderBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible,
        T2: OrderBySQLExpressible,
        T3: OrderBySQLExpressible
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
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible,
        T2: OrderBySQLExpressible,
        T3: OrderBySQLExpressible,
        T4: OrderBySQLExpressible
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
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible,
        T2: OrderBySQLExpressible,
        T3: OrderBySQLExpressible,
        T4: OrderBySQLExpressible,
        T5: OrderBySQLExpressible
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
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible,
        T2: OrderBySQLExpressible,
        T3: OrderBySQLExpressible,
        T4: OrderBySQLExpressible,
        T5: OrderBySQLExpressible,
        T6: OrderBySQLExpressible
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
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible,
        T2: OrderBySQLExpressible,
        T3: OrderBySQLExpressible,
        T4: OrderBySQLExpressible,
        T5: OrderBySQLExpressible,
        T6: OrderBySQLExpressible,
        T7: OrderBySQLExpressible
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
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible,
        T2: OrderBySQLExpressible,
        T3: OrderBySQLExpressible,
        T4: OrderBySQLExpressible,
        T5: OrderBySQLExpressible,
        T6: OrderBySQLExpressible,
        T7: OrderBySQLExpressible,
        T8: OrderBySQLExpressible
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
        T0: OrderBySQLExpressible,
        T1: OrderBySQLExpressible,
        T2: OrderBySQLExpressible,
        T3: OrderBySQLExpressible,
        T4: OrderBySQLExpressible,
        T5: OrderBySQLExpressible,
        T6: OrderBySQLExpressible,
        T7: OrderBySQLExpressible,
        T8: OrderBySQLExpressible,
        T9: OrderBySQLExpressible
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

extension OrderByTouple: OrderBySQLExpressible {
    public var orderBySqlExpression: some SQLExpression {
        SQLList(expressions)
    }
}
