import Foundation
import SQLKit

struct OrderByTouple<T> {
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
}

extension OrderByTouple: OrderBySQLExpressible {
    var orderBySqlExpression: OrderBy {
        .init(expressions: expressions)
    }
    
    struct OrderBy: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions).serialize(to: &serializer)
        }
    }
}
