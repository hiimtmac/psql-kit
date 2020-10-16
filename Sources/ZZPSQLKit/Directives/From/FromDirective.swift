import Foundation
import SQLKit

typealias FROM = FromDirective

struct FromDirective<Content>: SQLExpression where Content: FromSQLExpressible {
    let content: Content
    
    init(@FromBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    init(content: Content) {
        self.content = content
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("FROM")
        serializer.writeSpace()
        content.fromSqlExpression.serialize(to: &serializer)
    }
}
