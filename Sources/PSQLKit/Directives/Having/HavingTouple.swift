import Foundation
import SQLKit

public struct HavingTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression,
            value.2.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible,
        T3: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression,
            value.2.havingSqlExpression,
            value.3.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible,
        T3: HavingSQLExpressible,
        T4: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression,
            value.2.havingSqlExpression,
            value.3.havingSqlExpression,
            value.4.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5>(_ value: (T0, T1, T2, T3, T4, T5)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible,
        T3: HavingSQLExpressible,
        T4: HavingSQLExpressible,
        T5: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression,
            value.2.havingSqlExpression,
            value.3.havingSqlExpression,
            value.4.havingSqlExpression,
            value.5.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6>(_ value: (T0, T1, T2, T3, T4, T5, T6)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible,
        T3: HavingSQLExpressible,
        T4: HavingSQLExpressible,
        T5: HavingSQLExpressible,
        T6: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression,
            value.2.havingSqlExpression,
            value.3.havingSqlExpression,
            value.4.havingSqlExpression,
            value.5.havingSqlExpression,
            value.6.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible,
        T3: HavingSQLExpressible,
        T4: HavingSQLExpressible,
        T5: HavingSQLExpressible,
        T6: HavingSQLExpressible,
        T7: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression,
            value.2.havingSqlExpression,
            value.3.havingSqlExpression,
            value.4.havingSqlExpression,
            value.5.havingSqlExpression,
            value.6.havingSqlExpression,
            value.7.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible,
        T3: HavingSQLExpressible,
        T4: HavingSQLExpressible,
        T5: HavingSQLExpressible,
        T6: HavingSQLExpressible,
        T7: HavingSQLExpressible,
        T8: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression,
            value.2.havingSqlExpression,
            value.3.havingSqlExpression,
            value.4.havingSqlExpression,
            value.5.havingSqlExpression,
            value.6.havingSqlExpression,
            value.7.havingSqlExpression,
            value.8.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible,
        T3: HavingSQLExpressible,
        T4: HavingSQLExpressible,
        T5: HavingSQLExpressible,
        T6: HavingSQLExpressible,
        T7: HavingSQLExpressible,
        T8: HavingSQLExpressible,
        T9: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression,
            value.2.havingSqlExpression,
            value.3.havingSqlExpression,
            value.4.havingSqlExpression,
            value.5.havingSqlExpression,
            value.6.havingSqlExpression,
            value.7.havingSqlExpression,
            value.8.havingSqlExpression,
            value.9.havingSqlExpression
        ]
    }
}

extension HavingTouple: HavingSQLExpressible {
    public var havingSqlExpression: some SQLExpression {
        _Having(expressions: expressions)
    }
    
    private struct _Having: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions, separator: SQLRaw(" AND ")).serialize(to: &serializer)
        }
    }
}
