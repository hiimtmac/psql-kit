import Foundation
import SQLKit

public struct WithDirective<Content>: SQLExpression where Content: WithSQLExpressible {
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

extension WithDirective: QuerySQLExpressible {
    public var querySqlExpression: some SQLExpression{ self }
}
