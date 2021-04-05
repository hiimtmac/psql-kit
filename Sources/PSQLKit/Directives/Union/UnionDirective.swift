import Foundation
import SQLKit

public struct UnionDirective<Content>: SQLExpression where Content: UnionSQLExpression {
    let content: Content
    
    public init(@UnionBuilder builder: () -> Content) {
        self.content = builder()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        content.unionSqlExpression.serialize(to: &serializer)
    }
}

extension UnionDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
