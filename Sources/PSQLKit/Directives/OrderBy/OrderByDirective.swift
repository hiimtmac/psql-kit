import Foundation
import SQLKit

public enum OrderByDirection: String, SQLExpression {
    case asc = "ASC"
    case desc = "DESC"
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write(rawValue)
    }
}

public struct OrderByDirective<Content>: SQLExpression where Content: OrderBySQLExpressible {
    let content: Content
    
    public init(@OrderByBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("ORDER BY")
        serializer.writeSpace()
        content.orderBySqlExpression.serialize(to: &serializer)
    }
}

public struct OrderByModifier<Content>: OrderBySQLExpressible where Content: OrderBySQLExpressible {
    let content: Content
    let direction: OrderByDirection
    
    private struct _OrderBy: SQLExpression {
        let content: Content
        let direction: OrderByDirection
        
        func serialize(to serializer: inout SQLSerializer) {
            content.orderBySqlExpression.serialize(to: &serializer)
            serializer.writeSpace()
            direction.serialize(to: &serializer)
        }
    }
    
    public var orderBySqlExpression: some SQLExpression {
        _OrderBy(content: content, direction: direction)
    }
}

extension OrderByDirective: QuerySQLExpressible {
    public var querySqlExpression: some SQLExpression { self }
}
