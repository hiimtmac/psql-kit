import Foundation
import SQLKit

public struct GroupByTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible,
        T2: GroupBySQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression,
            value.2.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible,
        T2: GroupBySQLExpressible,
        T3: GroupBySQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression,
            value.2.groupBySqlExpression,
            value.3.groupBySqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: GroupBySQLExpressible,
        T1: GroupBySQLExpressible,
        T2: GroupBySQLExpressible,
        T3: GroupBySQLExpressible,
        T4: GroupBySQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.groupBySqlExpression,
            value.1.groupBySqlExpression,
            value.2.groupBySqlExpression,
            value.3.groupBySqlExpression,
            value.4.groupBySqlExpression
        ]
    }
}

extension GroupByTouple: GroupBySQLExpressible {
    public var groupBySqlExpression: some SQLExpression {
        _GroupBy(expressions: expressions)
    }
    
    private struct _GroupBy: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions).serialize(to: &serializer)
        }
    }
}
