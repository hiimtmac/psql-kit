import Foundation
import SQLKit

public struct GroupByTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible,
        T2: GroupBySQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression,
            value.2.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible,
        T2: GroupBySQLExpressible,
        T3: GroupBySQLExpressible
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
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible,
        T2: GroupBySQLExpressible,
        T3: GroupBySQLExpressible,
        T4: GroupBySQLExpressible
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
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible,
        T2: GroupBySQLExpressible,
        T3: GroupBySQLExpressible,
        T4: GroupBySQLExpressible,
        T5: GroupBySQLExpressible
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
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible,
        T2: GroupBySQLExpressible,
        T3: GroupBySQLExpressible,
        T4: GroupBySQLExpressible,
        T5: GroupBySQLExpressible,
        T6: GroupBySQLExpressible
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
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible,
        T2: GroupBySQLExpressible,
        T3: GroupBySQLExpressible,
        T4: GroupBySQLExpressible,
        T5: GroupBySQLExpressible,
        T6: GroupBySQLExpressible,
        T7: GroupBySQLExpressible
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
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible,
        T2: GroupBySQLExpressible,
        T3: GroupBySQLExpressible,
        T4: GroupBySQLExpressible,
        T5: GroupBySQLExpressible,
        T6: GroupBySQLExpressible,
        T7: GroupBySQLExpressible,
        T8: GroupBySQLExpressible
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
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible,
        T2: GroupBySQLExpressible,
        T3: GroupBySQLExpressible,
        T4: GroupBySQLExpressible,
        T5: GroupBySQLExpressible,
        T6: GroupBySQLExpressible,
        T7: GroupBySQLExpressible,
        T8: GroupBySQLExpressible,
        T9: GroupBySQLExpressible
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

extension GroupByTouple: GroupBySQLExpressible {
    public var groupBySqlExpression: some SQLExpression {
        _GroupBy(expressions: expressions)
    }
    
    private struct _GroupBy: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions).serialize(to: &serializer)
        }
    }
}
