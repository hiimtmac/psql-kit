import Foundation
import SQLKit

enum OrderByDirection: String, SQLExpression {
    case asc = "ASC"
    case desc = "DESC"
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write(rawValue)
    }
}

struct OrderByDirective<Content>: SQLExpression where Content: OrderBySQLExpressible {
    let content: Content
    
    init(@OrderByBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("ORDER BY")
        serializer.writeSpace()
        content.orderBySqlExpression.serialize(to: &serializer)
    }
}

struct OrderByModifier<Content>: OrderBySQLExpressible where Content: OrderBySQLExpressible {
    let content: Content
    let direction: OrderByDirection
    
    struct OrderBy: SQLExpression {
        let content: Content
        let direction: OrderByDirection
        
        func serialize(to serializer: inout SQLSerializer) {
            content.orderBySqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            direction.serialize(to: &serializer)
        }
    }
    
    var orderBySqlExpression: OrderBy {
        .init(content: content, direction: direction)
    }
}

extension OrderByDirective: QuerySQLExpressible {
    var querySqlExpression: Self { self }
}
