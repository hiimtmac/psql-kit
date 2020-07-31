import Foundation

typealias HAVING = HavingDirective

struct HavingDirective: Directive {
    var psql: PSQLExpression
    
    init(@CompareBuilder builder: () -> PSQLExpression) {
        self.psql = builder()
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("HAVING")
        serializer.writeSpace()
        psql.serialize(to: &serializer)
    }
}
