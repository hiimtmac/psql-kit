import Foundation
import SQLKit

public struct UnionTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: UnionSQLExpressible,
        T1: UnionSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.unionSqlExpression,
            value.1.unionSqlExpression
        ]
    }
    
    init<T0, T1, T2>( _ value: (T0, T1, T2)) where
        T0: UnionSQLExpressible,
        T1: UnionSQLExpressible,
        T2: UnionSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.unionSqlExpression,
            value.1.unionSqlExpression,
            value.2.unionSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>( _ value: (T0, T1, T2, T3)) where
        T0: UnionSQLExpressible,
        T1: UnionSQLExpressible,
        T2: UnionSQLExpressible,
        T3: UnionSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.unionSqlExpression,
            value.1.unionSqlExpression,
            value.2.unionSqlExpression,
            value.3.unionSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>( _ value: (T0, T1, T2, T3, T4)) where
        T0: UnionSQLExpressible,
        T1: UnionSQLExpressible,
        T2: UnionSQLExpressible,
        T3: UnionSQLExpressible,
        T4: UnionSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.unionSqlExpression,
            value.1.unionSqlExpression,
            value.2.unionSqlExpression,
            value.3.unionSqlExpression,
            value.4.unionSqlExpression
        ]
    }
}

extension UnionTouple: UnionSQLExpressible {
    public var unionSqlExpression: some SQLExpression {
        _Union(expressions: expressions)
    }
    
    private struct _Union: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions, separator: SQLRaw(" UNION ")).serialize(to: &serializer)
        }
    }
}
