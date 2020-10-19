import Foundation
import SQLKit

struct WithDirective<Content>: SQLExpression where Content: WithSQLExpressible {
    let content: Content
    
    init(@WithBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("WITH")
        serializer.writeSpace()
        content.withSqlExpression.serialize(to: &serializer)
    }
}

extension WithDirective: QuerySQLExpressible {
    var querySqlExpression: Self { self }
}
