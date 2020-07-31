import Foundation

typealias WHERE = WhereDirective

struct WhereDirective: Directive {
    var psql: PSQLExpression
    
    init(@CompareBuilder builder: () -> PSQLExpression) {
        self.psql = builder()
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("WHERE")
        serializer.writeSpace()
        psql.serialize(to: &serializer)
    }
}
