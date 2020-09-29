import Foundation

typealias SUM = SumExpression

struct SumExpression: PSQLExpression, AggregateFunctionExpression {
    let column: PSQLColumnExpression
    
    init<T>(_ column: Column<T>) {
        self.column = column.columnExpression
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("SUM")
        serializer.write("(")
        column.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension SumExpression: PSQLSelectExpression {
    var psqlSelectExpression: PSQLExpression { self }
}
