import Foundation
import SQLKit

public struct JoinTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: JoinSQLExpressible,
        T1: JoinSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: JoinSQLExpressible,
        T1: JoinSQLExpressible,
        T2: JoinSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: JoinSQLExpressible,
        T1: JoinSQLExpressible,
        T2: JoinSQLExpressible,
        T3: JoinSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: JoinSQLExpressible,
        T1: JoinSQLExpressible,
        T2: JoinSQLExpressible,
        T3: JoinSQLExpressible,
        T4: JoinSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression,
            value.4.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5>(_ value: (T0, T1, T2, T3, T4, T5)) where
        T0: JoinSQLExpressible,
        T1: JoinSQLExpressible,
        T2: JoinSQLExpressible,
        T3: JoinSQLExpressible,
        T4: JoinSQLExpressible,
        T5: JoinSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression,
            value.4.joinSqlExpression,
            value.5.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6>(_ value: (T0, T1, T2, T3, T4, T5, T6)) where
        T0: JoinSQLExpressible,
        T1: JoinSQLExpressible,
        T2: JoinSQLExpressible,
        T3: JoinSQLExpressible,
        T4: JoinSQLExpressible,
        T5: JoinSQLExpressible,
        T6: JoinSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression,
            value.4.joinSqlExpression,
            value.5.joinSqlExpression,
            value.6.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7)) where
        T0: JoinSQLExpressible,
        T1: JoinSQLExpressible,
        T2: JoinSQLExpressible,
        T3: JoinSQLExpressible,
        T4: JoinSQLExpressible,
        T5: JoinSQLExpressible,
        T6: JoinSQLExpressible,
        T7: JoinSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression,
            value.4.joinSqlExpression,
            value.5.joinSqlExpression,
            value.6.joinSqlExpression,
            value.7.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8)) where
        T0: JoinSQLExpressible,
        T1: JoinSQLExpressible,
        T2: JoinSQLExpressible,
        T3: JoinSQLExpressible,
        T4: JoinSQLExpressible,
        T5: JoinSQLExpressible,
        T6: JoinSQLExpressible,
        T7: JoinSQLExpressible,
        T8: JoinSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression,
            value.4.joinSqlExpression,
            value.5.joinSqlExpression,
            value.6.joinSqlExpression,
            value.7.joinSqlExpression,
            value.8.joinSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(_ value: (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9)) where
        T0: JoinSQLExpressible,
        T1: JoinSQLExpressible,
        T2: JoinSQLExpressible,
        T3: JoinSQLExpressible,
        T4: JoinSQLExpressible,
        T5: JoinSQLExpressible,
        T6: JoinSQLExpressible,
        T7: JoinSQLExpressible,
        T8: JoinSQLExpressible,
        T9: JoinSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.joinSqlExpression,
            value.1.joinSqlExpression,
            value.2.joinSqlExpression,
            value.3.joinSqlExpression,
            value.4.joinSqlExpression,
            value.5.joinSqlExpression,
            value.6.joinSqlExpression,
            value.7.joinSqlExpression,
            value.8.joinSqlExpression,
            value.9.joinSqlExpression
        ]
    }
}

extension JoinTouple: JoinSQLExpressible {
    public var joinSqlExpression: some SQLExpression {
        _Join(expressions: expressions)
    }
    
    private struct _Join: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions, separator: SQLRaw(" AND ")).serialize(to: &serializer)
        }
    }
}
