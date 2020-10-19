import Foundation
import SQLKit

struct HavingDirective<Content>: SQLExpression where Content: HavingSQLExpressible {
    let content: Content
    
    init(@HavingBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("HAVING")
        serializer.writeSpace()
        content.havingSqlExpression.serialize(to: &serializer)
    }
}

extension HavingDirective: QuerySQLExpressible {
    var querySqlExpression: Self { self }
}
