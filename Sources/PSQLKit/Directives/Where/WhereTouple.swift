import Foundation
import SQLKit

public struct WhereTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.whereSqlExpression,
            value.1.whereSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.whereSqlExpression,
            value.1.whereSqlExpression,
            value.2.whereSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible,
        T3: WhereSQLExpressible
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
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible,
        T3: WhereSQLExpressible,
        T4: WhereSQLExpressible
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
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible,
        T3: WhereSQLExpressible,
        T4: WhereSQLExpressible,
        T5: WhereSQLExpressible
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
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible,
        T3: WhereSQLExpressible,
        T4: WhereSQLExpressible,
        T5: WhereSQLExpressible,
        T6: WhereSQLExpressible
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
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible,
        T3: WhereSQLExpressible,
        T4: WhereSQLExpressible,
        T5: WhereSQLExpressible,
        T6: WhereSQLExpressible,
        T7: WhereSQLExpressible
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
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible,
        T3: WhereSQLExpressible,
        T4: WhereSQLExpressible,
        T5: WhereSQLExpressible,
        T6: WhereSQLExpressible,
        T7: WhereSQLExpressible,
        T8: WhereSQLExpressible
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
        T0: WhereSQLExpressible,
        T1: WhereSQLExpressible,
        T2: WhereSQLExpressible,
        T3: WhereSQLExpressible,
        T4: WhereSQLExpressible,
        T5: WhereSQLExpressible,
        T6: WhereSQLExpressible,
        T7: WhereSQLExpressible,
        T8: WhereSQLExpressible,
        T9: WhereSQLExpressible
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

extension WhereTouple: WhereSQLExpressible {
    public var whereSqlExpression: some SQLExpression {
        _Where(expressions: expressions)
    }
    
    private struct _Where: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions, separator: SQLRaw(" AND ")).serialize(to: &serializer)
        }
    }
}
