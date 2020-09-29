import Foundation
import FluentKit

typealias QUERY = QueryDirective

class QueryDirective: Directive {
    let alias: String?
    let type: QueryType
    var psql: PSQLExpression
    
    init(@QueryBuilder builder: () -> PSQLExpression) {
        self.alias = nil
        self.type = .default
        self.psql = builder()
    }
    
    init(alias: String, psql: PSQLExpression) {
        self.alias = alias
        self.type = .sub
        self.psql = psql
    }
    
    init(with: String, psql: PSQLExpression) {
        self.alias = with
        self.type = .with
        self.psql = psql
    }
    
    init(alias: String?, type: QueryType, psql: PSQLExpression) {
        self.alias = alias
        self.type = type
        self.psql = psql
    }
    
    func serialize(to serializer: inout PSQLSerializer) {
        switch type {
        case .default:
            psql.serialize(to: &serializer)
        case .sub:
            serializer.write("(")
            psql.serialize(to: &serializer)
            serializer.write(")")
            
            if let alias = alias {
                serializer.writeSpace()
                serializer.write("AS")
                serializer.writeSpace()
                serializer.writeQuote()
                serializer.write(alias)
                serializer.writeQuote()
            }
        case .with:
            if let alias = alias {
                serializer.writeQuote()
                serializer.write(alias)
                serializer.writeQuote()
                serializer.writeSpace()
                serializer.write("AS")
                serializer.writeSpace()
            }
            
            serializer.write("(")
            psql.serialize(to: &serializer)
            serializer.write(")")
        }
    }
    
    enum QueryType {
        case `default`
        case sub
        case with
    }
}

extension QueryDirective: PSQLSelectExpression {
    var psqlSelectExpression: PSQLExpression { self }
}

extension QueryDirective {
    func asSub(_ alias: String) -> QueryDirective {
        .init(alias: alias, type: .sub, psql: psql)
    }
    
    func asWith(_ alias: String) -> QueryDirective {
        .init(alias: alias, type: .with, psql: psql)
    }
        
    func asSub<T: Table>(_ table: T.Type) -> QueryDirective {
        .init(alias: table.schema, type: .sub, psql: psql)
    }
    
    func asSub<T: Table>(_ tableAlias: TableAlias<T>) -> QueryDirective {
        .init(alias: tableAlias.alias, type: .sub, psql: psql)
    }
    
    func asWith<T: Table>(_ table: T.Type) -> QueryDirective {
        .init(alias: table.schema, type: .with, psql: psql)
    }
    
    func asWith<T: Table>(_ tableAlias: TableAlias<T>) -> QueryDirective {
        .init(alias: tableAlias.alias, type: .with, psql: psql)
    }
}
