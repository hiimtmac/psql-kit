import Foundation
import SQLKit

public struct InsertTouple<T> {
    let value: T
    let columns: [SQLExpression]
    let values: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: InsertSQLExpression,
        T1: InsertSQLExpression
    {
        self.value = value as! T
        self.columns = [
            value.0.insertColumnSqlExpression,
            value.1.insertColumnSqlExpression
        ]
        self.values = [
            value.0.insertValueSqlExpression,
            value.1.insertValueSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: InsertSQLExpression,
        T1: InsertSQLExpression,
        T2: InsertSQLExpression
    {
        self.value = value as! T
        self.columns = [
            value.0.insertColumnSqlExpression,
            value.1.insertColumnSqlExpression,
            value.2.insertColumnSqlExpression
        ]
        self.values = [
            value.0.insertValueSqlExpression,
            value.1.insertValueSqlExpression,
            value.2.insertValueSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: InsertSQLExpression,
        T1: InsertSQLExpression,
        T2: InsertSQLExpression,
        T3: InsertSQLExpression
    {
        self.value = value as! T
        self.columns = [
            value.0.insertColumnSqlExpression,
            value.1.insertColumnSqlExpression,
            value.2.insertColumnSqlExpression,
            value.3.insertColumnSqlExpression
        ]
        self.values = [
            value.0.insertValueSqlExpression,
            value.1.insertValueSqlExpression,
            value.2.insertValueSqlExpression,
            value.3.insertValueSqlExpression
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
        self.columns = [
            value.0.insertColumnSqlExpression,
            value.1.insertColumnSqlExpression,
            value.2.insertColumnSqlExpression,
            value.3.insertColumnSqlExpression,
            value.4.insertColumnSqlExpression
        ]
        self.values = [
            value.0.insertValueSqlExpression,
            value.1.insertValueSqlExpression,
            value.2.insertValueSqlExpression,
            value.3.insertValueSqlExpression,
            value.4.insertValueSqlExpression
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
        self.columns = [
            value.0.insertColumnSqlExpression,
            value.1.insertColumnSqlExpression,
            value.2.insertColumnSqlExpression,
            value.3.insertColumnSqlExpression,
            value.4.insertColumnSqlExpression,
            value.5.insertColumnSqlExpression
        ]
        self.values = [
            value.0.insertValueSqlExpression,
            value.1.insertValueSqlExpression,
            value.2.insertValueSqlExpression,
            value.3.insertValueSqlExpression,
            value.4.insertValueSqlExpression,
            value.5.insertValueSqlExpression
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
        self.columns = [
            value.0.insertColumnSqlExpression,
            value.1.insertColumnSqlExpression,
            value.2.insertColumnSqlExpression,
            value.3.insertColumnSqlExpression,
            value.4.insertColumnSqlExpression,
            value.5.insertColumnSqlExpression,
            value.6.insertColumnSqlExpression
        ]
        self.values = [
            value.0.insertValueSqlExpression,
            value.1.insertValueSqlExpression,
            value.2.insertValueSqlExpression,
            value.3.insertValueSqlExpression,
            value.4.insertValueSqlExpression,
            value.5.insertValueSqlExpression,
            value.6.insertValueSqlExpression
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
        self.columns = [
            value.0.insertColumnSqlExpression,
            value.1.insertColumnSqlExpression,
            value.2.insertColumnSqlExpression,
            value.3.insertColumnSqlExpression,
            value.4.insertColumnSqlExpression,
            value.5.insertColumnSqlExpression,
            value.6.insertColumnSqlExpression,
            value.7.insertColumnSqlExpression
        ]
        self.values = [
            value.0.insertValueSqlExpression,
            value.1.insertValueSqlExpression,
            value.2.insertValueSqlExpression,
            value.3.insertValueSqlExpression,
            value.4.insertValueSqlExpression,
            value.5.insertValueSqlExpression,
            value.6.insertValueSqlExpression,
            value.7.insertValueSqlExpression
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
        self.columns = [
            value.0.insertColumnSqlExpression,
            value.1.insertColumnSqlExpression,
            value.2.insertColumnSqlExpression,
            value.3.insertColumnSqlExpression,
            value.4.insertColumnSqlExpression,
            value.5.insertColumnSqlExpression,
            value.6.insertColumnSqlExpression,
            value.7.insertColumnSqlExpression,
            value.8.insertColumnSqlExpression
        ]
        self.values = [
            value.0.insertValueSqlExpression,
            value.1.insertValueSqlExpression,
            value.2.insertValueSqlExpression,
            value.3.insertValueSqlExpression,
            value.4.insertValueSqlExpression,
            value.5.insertValueSqlExpression,
            value.6.insertValueSqlExpression,
            value.7.insertValueSqlExpression,
            value.8.insertValueSqlExpression
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
        self.columns = [
            value.0.insertColumnSqlExpression,
            value.1.insertColumnSqlExpression,
            value.2.insertColumnSqlExpression,
            value.3.insertColumnSqlExpression,
            value.4.insertColumnSqlExpression,
            value.5.insertColumnSqlExpression,
            value.6.insertColumnSqlExpression,
            value.7.insertColumnSqlExpression,
            value.8.insertColumnSqlExpression,
            value.9.insertColumnSqlExpression
        ]
        self.values = [
            value.0.insertValueSqlExpression,
            value.1.insertValueSqlExpression,
            value.2.insertValueSqlExpression,
            value.3.insertValueSqlExpression,
            value.4.insertValueSqlExpression,
            value.5.insertValueSqlExpression,
            value.6.insertValueSqlExpression,
            value.7.insertValueSqlExpression,
            value.8.insertValueSqlExpression,
            value.9.insertValueSqlExpression
        ]
    }
}

extension InsertTouple: InsertSQLExpression {
    public var insertColumnSqlExpression: some SQLExpression {
        SQLList(columns)
    }
    
    public var insertValueSqlExpression: some SQLExpression {
        SQLList(values)
    }
}
