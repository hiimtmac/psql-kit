import Foundation

struct ToupleStatement<T> {
    let value: T
    let expressions: [PSQLExpression]
    
//    init(_ value: T) {
//        self.value = value
//        self.expressions = []
//    }
    
    init<T0>(_ value: T0) where T0: PSQLSelectExpression {
        self.value = value as! T
        self.expressions = [value.psqlSelectExpression]
    }

    init<T0, T1>(_ value: (T0, T1)) where T0: PSQLSelectExpression, T1: PSQLSelectExpression {
        self.value = value as! T
        self.expressions = [value.0.psqlSelectExpression, value.1.psqlSelectExpression]
    }

    init<T0, T1, T2>(_ value: (T0, T1, T2)) where T0: PSQLSelectExpression, T1: PSQLSelectExpression, T2: PSQLSelectExpression {
        self.value = value as! T
        self.expressions = [value.0.psqlSelectExpression, value.1.psqlSelectExpression, value.2.psqlSelectExpression]
    }

    init<T0, T1, T2, T3>(_ value: (T0, T1, T2, T3)) where T0: PSQLSelectExpression, T1: PSQLSelectExpression, T2: PSQLSelectExpression, T3: PSQLSelectExpression {
        self.value = value as! T
        self.expressions = [value.0.psqlSelectExpression, value.1.psqlSelectExpression, value.2.psqlSelectExpression, value.3.psqlSelectExpression]
    }

    init<T0, T1, T2, T3, T4>(_ value: (T0, T1, T2, T3, T4)) where T0: PSQLSelectExpression, T1: PSQLSelectExpression, T2: PSQLSelectExpression, T3: PSQLSelectExpression, T4: PSQLSelectExpression {
        self.value = value as! T
        self.expressions = [value.0.psqlSelectExpression, value.1.psqlSelectExpression, value.2.psqlSelectExpression, value.3.psqlSelectExpression, value.4.psqlSelectExpression]
    }
}

extension ToupleStatement: PSQLExpression {
    func serialize(to serializer: inout PSQLSerializer) {
        PSQLList(expressions).serialize(to: &serializer)
    }
}

extension ToupleStatement: PSQLSelectExpression {
    var psqlSelectExpression: PSQLExpression { self }
}
