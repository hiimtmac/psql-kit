import Foundation
import SQLKit

struct FromDirective<Content>: SQLExpression where Content: FromSQLExpressible {
    let content: Content
    
    init(@FromBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("FROM")
        serializer.writeSpace()
        content.fromSqlExpression.serialize(to: &serializer)
    }
}

extension FromDirective: QuerySQLExpressible {
    var querySqlExpression: Self { self }
}
