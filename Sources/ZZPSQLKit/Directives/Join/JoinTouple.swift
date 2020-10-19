import Foundation
import SQLKit

struct JoinTouple<T> {
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
}

extension JoinTouple: JoinSQLExpressible {
    var joinSqlExpression: Join {
        .init(expressions: expressions)
    }
    
    struct Join: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions, separator: SQLRaw(" AND ")).serialize(to: &serializer)
        }
    }
}
