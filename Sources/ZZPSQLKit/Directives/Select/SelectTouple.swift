import Foundation
import SQLKit

struct SelectTouple<T> {
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
}

extension SelectTouple: SelectSQLExpressible {
    var selectSqlExpression: Select {
        .init(expressions: expressions)
    }
    
    struct Select: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions).serialize(to: &serializer)
        }
    }
}
