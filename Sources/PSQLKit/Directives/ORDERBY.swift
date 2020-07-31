import Foundation

typealias ORDERBY = OrderByDirective

struct OrderByDirective: Directive {
    var psql: PSQLExpression
    
    init(@OrderByBuilder builder: () -> PSQLExpression) {
        self.psql = builder()
    }
    
//    init<T: ExpressibleByOrderBy>(@OrderByBuilder builder: () -> T) {
//        self.psql = builder().orderBy
//    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("ORDER BY")
        serializer.writeSpace()
        psql.serialize(to: &serializer)
    }
}
