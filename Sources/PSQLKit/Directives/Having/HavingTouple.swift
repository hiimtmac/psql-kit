import Foundation
import SQLKit

public struct HavingTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: HavingSQLExpression,
        T1: HavingSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: HavingSQLExpression,
        T1: HavingSQLExpression,
        T2: HavingSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression,
            value.2.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: HavingSQLExpression,
        T1: HavingSQLExpression,
        T2: HavingSQLExpression,
        T3: HavingSQLExpression
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
        T0: HavingSQLExpression,
        T1: HavingSQLExpression,
        T2: HavingSQLExpression,
        T3: HavingSQLExpression,
        T4: HavingSQLExpression
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
        T0: HavingSQLExpression,
        T1: HavingSQLExpression,
        T2: HavingSQLExpression,
        T3: HavingSQLExpression,
        T4: HavingSQLExpression,
        T5: HavingSQLExpression
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
        T0: HavingSQLExpression,
        T1: HavingSQLExpression,
        T2: HavingSQLExpression,
        T3: HavingSQLExpression,
        T4: HavingSQLExpression,
        T5: HavingSQLExpression,
        T6: HavingSQLExpression
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
        T0: HavingSQLExpression,
        T1: HavingSQLExpression,
        T2: HavingSQLExpression,
        T3: HavingSQLExpression,
        T4: HavingSQLExpression,
        T5: HavingSQLExpression,
        T6: HavingSQLExpression,
        T7: HavingSQLExpression
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
        T0: HavingSQLExpression,
        T1: HavingSQLExpression,
        T2: HavingSQLExpression,
        T3: HavingSQLExpression,
        T4: HavingSQLExpression,
        T5: HavingSQLExpression,
        T6: HavingSQLExpression,
        T7: HavingSQLExpression,
        T8: HavingSQLExpression
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
        T0: HavingSQLExpression,
        T1: HavingSQLExpression,
        T2: HavingSQLExpression,
        T3: HavingSQLExpression,
        T4: HavingSQLExpression,
        T5: HavingSQLExpression,
        T6: HavingSQLExpression,
        T7: HavingSQLExpression,
        T8: HavingSQLExpression,
        T9: HavingSQLExpression
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

extension HavingTouple: HavingSQLExpression {
    public var havingSqlExpression: some SQLExpression {
        SQLList(expressions, separator: SQLRaw(" AND "))
    }
}
