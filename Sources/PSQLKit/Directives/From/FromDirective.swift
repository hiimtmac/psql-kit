import Foundation
import SQLKit

public struct FromDirective: SQLExpression {
    let content: [FromSQLExpression]
    
    public init(@FromBuilder builder: () -> [FromSQLExpression]) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if !content.isEmpty {
            serializer.write("FROM")
            serializer.writeSpace()
            SQLList(content.map(\.fromSqlExpression))
                .serialize(to: &serializer)
        }
    }
}

extension FromDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
