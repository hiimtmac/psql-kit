import Foundation
import SQLKit

public struct GroupByDirective: SQLExpression {
    let content: [GroupBySQLExpression]
    
    public init(@GroupByBuilder builder: () -> [GroupBySQLExpression]) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        if !content.isEmpty {
            serializer.write("GROUP BY")
            serializer.writeSpace()
            SQLList(content.map(\.groupBySqlExpression))
                .serialize(to: &serializer)
        }
    }
}

extension GroupByDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
