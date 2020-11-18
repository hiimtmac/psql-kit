import Foundation
import SQLKit

public struct HavingDirective<Content>: SQLExpression where Content: HavingSQLExpression {
    let content: Content
    
    public init(@HavingBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("HAVING")
        serializer.writeSpace()
        content.havingSqlExpression.serialize(to: &serializer)
    }
}

extension HavingDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
