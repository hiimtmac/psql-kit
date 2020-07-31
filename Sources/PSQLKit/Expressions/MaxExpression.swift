import Foundation

typealias MAX = MaxExpression

struct MaxExpression: PSQLExpression, AggregateFunctionExpression {
    let column: PSQLColumnExpression
    
    init<T>(_ column: PSQLTypedColumnExpression<T>) {
        self.column = column.column
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("MAX")
        serializer.write("(")
        column.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension MaxExpression: ExpressibleAsSelect {
    var select: PSQLExpression { self }
}
