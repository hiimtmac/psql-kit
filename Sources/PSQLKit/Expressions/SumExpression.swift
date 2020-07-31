import Foundation

typealias SUM = SumExpression

struct SumExpression: PSQLExpression, AggregateFunctionExpression {
    let column: PSQLColumnExpression
    
    init<T>(_ column: PSQLTypedColumnExpression<T>) {
        self.column = column.column
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("SUM")
        serializer.write("(")
        column.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension SumExpression: ExpressibleAsSelect {
    var select: PSQLExpression { self }
}
