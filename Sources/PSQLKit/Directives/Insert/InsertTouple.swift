import Foundation
import SQLKit

public struct InsertTouple<T> {
    let value: T
    let expressions: [InsertSQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: InsertSQLExpression,
        T1: InsertSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: InsertSQLExpression,
        T1: InsertSQLExpression,
        T2: InsertSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1,
            value.2
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: InsertSQLExpression,
        T1: InsertSQLExpression,
        T2: InsertSQLExpression,
        T3: InsertSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1,
            value.2,
            value.3
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: InsertSQLExpression,
        T1: InsertSQLExpression,
        T2: InsertSQLExpression,
        T3: InsertSQLExpression,
        T4: InsertSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1,
            value.2,
            value.3,
            value.4
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5>(_ value: (T0, T1, T2, T3, T4, T5)) where
        T0: InsertSQLExpression,
        T1: InsertSQLExpression,
        T2: InsertSQLExpression,
        T3: InsertSQLExpression,
        T4: InsertSQLExpression,
        T5: InsertSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1,
            value.2,
            value.3,
            value.4,
            value.5
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6>(_ value: (T0, T1, T2, T3, T4, T5, T6)) where
        T0: InsertSQLExpression,
        T1: InsertSQLExpression,
        T2: InsertSQLExpression,
        T3: InsertSQLExpression,
        T4: InsertSQLExpression,
        T5: InsertSQLExpression,
        T6: InsertSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1,
            value.2,
            value.3,
            value.4,
            value.5,
            value.6
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7)) where
        T0: InsertSQLExpression,
        T1: InsertSQLExpression,
        T2: InsertSQLExpression,
        T3: InsertSQLExpression,
        T4: InsertSQLExpression,
        T5: InsertSQLExpression,
        T6: InsertSQLExpression,
        T7: InsertSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1,
            value.2,
            value.3,
            value.4,
            value.5,
            value.6,
            value.7
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8)) where
        T0: InsertSQLExpression,
        T1: InsertSQLExpression,
        T2: InsertSQLExpression,
        T3: InsertSQLExpression,
        T4: InsertSQLExpression,
        T5: InsertSQLExpression,
        T6: InsertSQLExpression,
        T7: InsertSQLExpression,
        T8: InsertSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1,
            value.2,
            value.3,
            value.4,
            value.5,
            value.6,
            value.7,
            value.8
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) where
        T0: InsertSQLExpression,
        T1: InsertSQLExpression,
        T2: InsertSQLExpression,
        T3: InsertSQLExpression,
        T4: InsertSQLExpression,
        T5: InsertSQLExpression,
        T6: InsertSQLExpression,
        T7: InsertSQLExpression,
        T8: InsertSQLExpression,
        T9: InsertSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1,
            value.2,
            value.3,
            value.4,
            value.5,
            value.6,
            value.7,
            value.8,
            value.9
        ]
    }
}

extension InsertTouple: InsertSQLExpression {
    public var insertColumnSqlExpression: SQLExpression {
        SQLList(expressions.map(\.insertColumnSqlExpression))
    }
    
    public var insertValueSqlExpression: SQLExpression {
        SQLList(expressions.map(\.insertValueSqlExpression))
    }
}
