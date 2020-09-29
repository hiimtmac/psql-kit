import Foundation

typealias MAX = MaxExpression

struct MaxExpression: PSQLExpression, AggregateFunctionExpression {
    let column: PSQLColumnExpression
    
    init<T>(_ column: Column<T>) {
        self.column = column.columnExpression
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("MAX")
        serializer.write("(")
        column.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension MaxExpression: PSQLSelectExpression {
    var psqlSelectExpression: PSQLExpression { self }
}
