import Foundation
import SQLKit

public struct QueryTouple<T> {
    let value: T
    let expressions: [QuerySQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: QuerySQLExpression,
        T1: QuerySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression
    {
        self.value = value as! T
        self.expressions = [
            value.0,
            value.1,
            value.2
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression
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
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression,
        T4: QuerySQLExpression
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
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression,
        T4: QuerySQLExpression,
        T5: QuerySQLExpression
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
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression,
        T4: QuerySQLExpression,
        T5: QuerySQLExpression,
        T6: QuerySQLExpression
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
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression,
        T4: QuerySQLExpression,
        T5: QuerySQLExpression,
        T6: QuerySQLExpression,
        T7: QuerySQLExpression
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
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression,
        T4: QuerySQLExpression,
        T5: QuerySQLExpression,
        T6: QuerySQLExpression,
        T7: QuerySQLExpression,
        T8: QuerySQLExpression
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
        T0: QuerySQLExpression,
        T1: QuerySQLExpression,
        T2: QuerySQLExpression,
        T3: QuerySQLExpression,
        T4: QuerySQLExpression,
        T5: QuerySQLExpression,
        T6: QuerySQLExpression,
        T7: QuerySQLExpression,
        T8: QuerySQLExpression,
        T9: QuerySQLExpression
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

extension QueryTouple: QuerySQLExpression {
    public var querySqlExpression: SQLExpression {
        SQLList(expressions.map(\.querySqlExpression), separator: SQLRaw(" "))
    }
}
