import Foundation

typealias GROUPBY = GroupByDirective

struct GroupByDirective: Directive {
    var psql: PSQLExpression
    
    init(@GroupByBuilder builder: () -> PSQLExpression) {
        self.psql = builder()
    }
    
    init<T: ExpressibleAsGroupBy>(@GroupByBuilder builder: () -> T) {
        self.psql = builder().groupBy
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write("GROUP BY")
        serializer.writeSpace()
        psql.serialize(to: &serializer)
    }
}
