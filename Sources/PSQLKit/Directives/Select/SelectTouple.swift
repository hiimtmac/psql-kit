import Foundation
import SQLKit

public struct SelectTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible,
        T2: SelectSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression,
            value.2.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible,
        T2: SelectSQLExpressible,
        T3: SelectSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression,
            value.2.selectSqlExpression,
            value.3.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible,
        T2: SelectSQLExpressible,
        T3: SelectSQLExpressible,
        T4: SelectSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression,
            value.2.selectSqlExpression,
            value.3.selectSqlExpression,
            value.4.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5>(_ value: (T0, T1, T2, T3, T4, T5)) where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible,
        T2: SelectSQLExpressible,
        T3: SelectSQLExpressible,
        T4: SelectSQLExpressible,
        T5: SelectSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression,
            value.2.selectSqlExpression,
            value.3.selectSqlExpression,
            value.4.selectSqlExpression,
            value.5.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6>(_ value: (T0, T1, T2, T3, T4, T5, T6)) where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible,
        T2: SelectSQLExpressible,
        T3: SelectSQLExpressible,
        T4: SelectSQLExpressible,
        T5: SelectSQLExpressible,
        T6: SelectSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression,
            value.2.selectSqlExpression,
            value.3.selectSqlExpression,
            value.4.selectSqlExpression,
            value.5.selectSqlExpression,
            value.6.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7)) where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible,
        T2: SelectSQLExpressible,
        T3: SelectSQLExpressible,
        T4: SelectSQLExpressible,
        T5: SelectSQLExpressible,
        T6: SelectSQLExpressible,
        T7: SelectSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression,
            value.2.selectSqlExpression,
            value.3.selectSqlExpression,
            value.4.selectSqlExpression,
            value.5.selectSqlExpression,
            value.6.selectSqlExpression,
            value.7.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8)) where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible,
        T2: SelectSQLExpressible,
        T3: SelectSQLExpressible,
        T4: SelectSQLExpressible,
        T5: SelectSQLExpressible,
        T6: SelectSQLExpressible,
        T7: SelectSQLExpressible,
        T8: SelectSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression,
            value.2.selectSqlExpression,
            value.3.selectSqlExpression,
            value.4.selectSqlExpression,
            value.5.selectSqlExpression,
            value.6.selectSqlExpression,
            value.7.selectSqlExpression,
            value.8.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) where
        T0: SelectSQLExpressible,
        T1: SelectSQLExpressible,
        T2: SelectSQLExpressible,
        T3: SelectSQLExpressible,
        T4: SelectSQLExpressible,
        T5: SelectSQLExpressible,
        T6: SelectSQLExpressible,
        T7: SelectSQLExpressible,
        T8: SelectSQLExpressible,
        T9: SelectSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression,
            value.2.selectSqlExpression,
            value.3.selectSqlExpression,
            value.4.selectSqlExpression,
            value.5.selectSqlExpression,
            value.6.selectSqlExpression,
            value.7.selectSqlExpression,
            value.8.selectSqlExpression,
            value.9.selectSqlExpression
        ]
    }
}

extension SelectTouple: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression {
        SQLList(expressions)
    }
}
