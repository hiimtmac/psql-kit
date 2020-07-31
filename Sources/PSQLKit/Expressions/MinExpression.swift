import Foundation

typealias MIN = MinExpression

struct MinExpression: PSQLExpression, AggregateFunctionExpression {
    let column: PSQLColumnExpression
    
    init<T>(_ column: PSQLTypedColumnExpression<T>) {
        self.column = column.column
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("MIN")
        serializer.write("(")
        column.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension MinExpression: ExpressibleAsSelect {
    var select: PSQLExpression { self }
}
