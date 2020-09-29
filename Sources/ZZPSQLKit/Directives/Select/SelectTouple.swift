import Foundation
import SQLKit

struct SelectTouple<T> {
    let value: T
    let expressions: [SQLExpression]
    
    init<T0, T1>( _ value: (
        ColumnExpression<T0>,
        ColumnExpression<T1>
    )) {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2>(_ value: (
        ColumnExpression<T0>,
        ColumnExpression<T1>,
        ColumnExpression<T2>
    )) {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression,
            value.2.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3>(_ value: (
        ColumnExpression<T0>,
        ColumnExpression<T1>,
        ColumnExpression<T2>,
        ColumnExpression<T3>
    )) {
        self.value = value as! T
        self.expressions = [
            value.0.selectSqlExpression,
            value.1.selectSqlExpression,
            value.2.selectSqlExpression,
            value.3.selectSqlExpression
        ]
    }
    
    init<T0, T1, T2, T3, T4>(_ value: (
        ColumnExpression<T0>,
        ColumnExpression<T1>,
        ColumnExpression<T2>,
        ColumnExpression<T3>,
        ColumnExpression<T4>
    )) {
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
