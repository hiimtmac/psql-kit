import Foundation
import SQLKit

public struct WithDirective<Content>: SQLExpression where Content: WithSQLExpression {
    let content: Content
    
    public init(@WithBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("WITH")
        serializer.writeSpace()
        content.withSqlExpression.serialize(to: &serializer)
    }
}

extension WithDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression{ self }
}
