import Foundation
import SQLKit

public struct ReturningDirective: SQLExpression {
    let content: [SelectSQLExpression]
    
    public init(@SelectBuilder builder: () -> [SelectSQLExpression]) {
        self.content = builder()
    }
    
    init(content: [SelectSQLExpression]) {
        self.content = content
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if !content.isEmpty {
            serializer.write("RETURNING")
            serializer.writeSpace()
            SQLList(content.map(\.selectSqlExpression))
                .serialize(to: &serializer)
        }
    }
}

extension ReturningDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
