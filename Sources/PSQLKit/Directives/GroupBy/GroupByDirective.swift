import Foundation
import SQLKit

public struct GroupByDirective<Content>: SQLExpression where Content: GroupBySQLExpression {
    let content: Content
    
    public init(@GroupByBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("GROUP BY")
        serializer.writeSpace()
        content.groupBySqlExpression.serialize(to: &serializer)
    }
}

extension GroupByDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
