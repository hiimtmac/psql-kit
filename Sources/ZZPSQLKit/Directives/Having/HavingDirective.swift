import Foundation
import SQLKit

typealias HAVING = HavingDirective

struct HavingDirective<Content>: SQLExpression where Content: HavingSQLExpressible {
    let content: Content
    
    init(@HavingBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    init(content: Content) {
        self.content = content
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        serializer.write("HAVING")
        serializer.writeSpace()
        content.havingSqlExpression.serialize(to: &serializer)
    }
}
