import Foundation
import SQLKit

struct HavingTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (T0, T1)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (T0, T1, T2)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression,
            value.2.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible,
        T3: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression,
            value.2.havingSqlExpression,
            value.3.havingSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where
        T0: HavingSQLExpressible,
        T1: HavingSQLExpressible,
        T2: HavingSQLExpressible,
        T3: HavingSQLExpressible,
        T4: HavingSQLExpressible
    {
        self.value = value as! T
        self.expressions = [
            value.0.havingSqlExpression,
            value.1.havingSqlExpression,
            value.2.havingSqlExpression,
            value.3.havingSqlExpression,
            value.4.havingSqlExpression
        ]
    }
}

extension HavingTouple: HavingSQLExpressible {
    var havingSqlExpression: Having {
        .init(expressions: expressions)
    }
    
    struct Having: SQLExpression {
        let expressions: [SQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(expressions).serialize(to: &serializer)
        }
    }
}
