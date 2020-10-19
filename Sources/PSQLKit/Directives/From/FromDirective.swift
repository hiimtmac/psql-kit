import Foundation
import SQLKit

public struct FromDirective<Content>: SQLExpression where Content: FromSQLExpressible {
    let content: Content
    
    public init(@FromBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("FROM")
        serializer.writeSpace()
        content.fromSqlExpression.serialize(to: &serializer)
    }
}

extension FromDirective: QuerySQLExpressible {
    public var querySqlExpression: some SQLExpression { self }
}
