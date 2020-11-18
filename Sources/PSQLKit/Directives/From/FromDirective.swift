import Foundation
import SQLKit

public struct FromDirective<Content>: SQLExpression where Content: FromSQLExpression {
    let content: Content
    
    public init(@FromBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if content is EmptyExpression { return }
        
        serializer.write("FROM")
        serializer.writeSpace()
        content.fromSqlExpression.serialize(to: &serializer)
    }
}

extension FromDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
