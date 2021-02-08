import Foundation
import SQLKit

public struct ReturningDirective<Content>: SQLExpression where Content: SelectSQLExpression {
    let content: Content
    
    public init(@SelectBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    init(content: Content) {
        self.content = content
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("RETURNING")
        serializer.writeSpace()
        content.selectSqlExpression.serialize(to: &serializer)
    }
}

extension ReturningDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
