import Foundation
import SQLKit

public struct DeleteDirective<Content>: SQLExpression where Content: FromSQLExpression {
    let content: Content
    
    public init(@FromBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("DELETE FROM")
        serializer.writeSpace()
        content.fromSqlExpression.serialize(to: &serializer)
    }
}

extension DeleteDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
