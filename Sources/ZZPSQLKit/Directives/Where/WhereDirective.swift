import Foundation
import SQLKit

typealias WHERE = WhereDirective

struct WhereDirective<Content>: SQLExpression where Content: WhereSQLExpressible {
    let content: Content
    
    init(@WhereBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("WHERE")
        serializer.writeSpace()
        content.whereSqlExpression.serialize(to: &serializer)
    }
}
