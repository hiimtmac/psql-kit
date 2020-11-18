import Foundation
import SQLKit

public struct WhereDirective<Content>: SQLExpression where Content: WhereSQLExpression {
    let content: Content
    
    public init(@WhereBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("WHERE")
        serializer.writeSpace()
        content.whereSqlExpression.serialize(to: &serializer)
    }
}

extension WhereDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
