import Foundation
import SQLKit

public struct SelectTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: SelectSQLExpression,
        T1: SelectSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: SelectSQLExpression,
        T1: SelectSQLExpression,
        T2: SelectSQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression,
            value.2.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: SelectSQLExpression,
        T1: SelectSQLExpression,
        T2: SelectSQLExpression,
        T3: SelectSQLExpression
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
        T0: SelectSQLExpression,
        T1: SelectSQLExpression,
        T2: SelectSQLExpression,
        T3: SelectSQLExpression,
        T4: SelectSQLExpression
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
        T0: SelectSQLExpression,
        T1: SelectSQLExpression,
        T2: SelectSQLExpression,
        T3: SelectSQLExpression,
        T4: SelectSQLExpression,
        T5: SelectSQLExpression
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
        T0: SelectSQLExpression,
        T1: SelectSQLExpression,
        T2: SelectSQLExpression,
        T3: SelectSQLExpression,
        T4: SelectSQLExpression,
        T5: SelectSQLExpression,
        T6: SelectSQLExpression
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
        T0: SelectSQLExpression,
        T1: SelectSQLExpression,
        T2: SelectSQLExpression,
        T3: SelectSQLExpression,
        T4: SelectSQLExpression,
        T5: SelectSQLExpression,
        T6: SelectSQLExpression,
        T7: SelectSQLExpression
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
        T0: SelectSQLExpression,
        T1: SelectSQLExpression,
        T2: SelectSQLExpression,
        T3: SelectSQLExpression,
        T4: SelectSQLExpression,
        T5: SelectSQLExpression,
        T6: SelectSQLExpression,
        T7: SelectSQLExpression,
        T8: SelectSQLExpression
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
        T0: SelectSQLExpression,
        T1: SelectSQLExpression,
        T2: SelectSQLExpression,
        T3: SelectSQLExpression,
        T4: SelectSQLExpression,
        T5: SelectSQLExpression,
        T6: SelectSQLExpression,
        T7: SelectSQLExpression,
        T8: SelectSQLExpression,
        T9: SelectSQLExpression
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
    
    public static func buildEither<Content>(first: Content) -> Content where Content: SelectSQLExpression {
        first
    }

    public static func buildEither<Content>(second: Content) -> Content where Content: SelectSQLExpression {
        second
    }
}

extension SelectTouple: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        SQLList(expressions)
    }
}
