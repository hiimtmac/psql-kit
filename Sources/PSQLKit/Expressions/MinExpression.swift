import Foundation

typealias MIN = MinExpression

struct MinExpression: PSQLExpression, AggregateFunctionExpression {
    let column: PSQLColumnExpression
    
    init<T>(_ column: Column<T>) {
        self.column = column.columnExpression
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("MIN")
        serializer.write("(")
        column.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension MinExpression: PSQLSelectExpression {
    var psqlSelectExpression: PSQLExpression { self }
}
