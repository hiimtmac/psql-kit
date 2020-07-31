import Foundation

typealias WITH = WithDirective

struct WithDirective: Directive {
    var psql: PSQLExpression
    
    init(@WithBuilder builder: () -> PSQLExpression) {
        self.psql = builder()
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("WITH")
        serializer.writeSpace()
        psql.serialize(to: &serializer)
    }
}
