import Foundation

typealias FROM = FromDirective

struct FromDirective: Directive {
    var psql: PSQLExpression
    
    init(@FromBuilder builder: () -> PSQLExpression) {
        self.psql = builder()
    }

    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("FROM")
        serializer.writeSpace()
        psql.serialize(to: &serializer)
    }
}
