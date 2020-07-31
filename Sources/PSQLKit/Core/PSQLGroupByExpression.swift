import Foundation

protocol ExpressibleAsGroupBy {
    var groupBy: PSQLExpression { get }
}

struct PSQLGroupByExpression: PSQLExpression {
    let column: PSQLColumnExpression
    
    func serialize(to serializer: inout PSQLSerializer) {
        column.serialize(to: &serializer)
    }
}

extension PSQLGroupByExpression: ExpressibleAsGroupBy {
    var groupBy: PSQLExpression { self }
}
