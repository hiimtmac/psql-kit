import Foundation
import SQLKit

public struct DeleteDirective: SQLExpression {
    let content: [FromSQLExpression]
    
    public init(@FromBuilder builder: () -> [FromSQLExpression]) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if !content.isEmpty {
            serializer.write("DELETE FROM")
            serializer.writeSpace()
            SQLList(content.map(\.fromSqlExpression))
                .serialize(to: &serializer)
        }
    }
}

extension DeleteDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
