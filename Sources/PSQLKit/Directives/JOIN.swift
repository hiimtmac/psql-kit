import Foundation

typealias JOIN = JoinDirective

struct JoinDirective: Directive {
    let table: PSQLExpression
    let type: JoinType
    var psql: PSQLExpression
    
    enum JoinType: String {
        case inner = "INNER"
        case outer = "OUTER"
        case left = "LEFT"
    }
    
    init<T: ExpressibleAsFrom>(_ table: T, type: JoinType = .inner, @CompareBuilder builder: () -> PSQLExpression) {
        self.table = table.from
        self.type = type
        self.psql = builder()
    }
    
    init(table: PSQLExpression, type: JoinType, psql: PSQLExpression) {
        self.table = table
        self.type = type
        self.psql = psql
    }
        
    func serialize(to serializer: inout PSQLSerializer) {
        serializer.write(type.rawValue)
        serializer.writeSpace()
        serializer.write("JOIN")
        serializer.writeSpace()
        table.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write("ON")
        serializer.writeSpace()
        psql.serialize(to: &serializer)
    }
}

extension JoinDirective {
    func type(_ join: JoinType) -> Self {
        .init(table: table, type: join, psql: psql)
    }
}
