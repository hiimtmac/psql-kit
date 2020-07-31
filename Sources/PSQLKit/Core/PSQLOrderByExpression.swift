import Foundation

protocol ExpressibleAsOrderBy {
    var orderBy: PSQLExpression { get }
}

struct PSQLOrderByExpression: PSQLExpression {
    let column: PSQLColumnExpression
    let order: Order
    
    init(column: PSQLColumnExpression, order: Order = .asc) {
        self.column = column
        self.order = order
    }
    
    enum Order: String {
        case asc = "ASC"
        case desc = "DESC"
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        column.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write(order.rawValue)
    }
}

extension PSQLOrderByExpression: ExpressibleAsOrderBy {
    var orderBy: PSQLExpression { self }
}

extension PSQLOrderByExpression {
    func direction(_ order: Order) -> Self {
        .init(column: column, order: order)
    }
}
