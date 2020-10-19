import Foundation
import SQLKit

typealias QUERY = QueryDirective

struct QueryDirective<Content>: SQLExpression where Content: QuerySQLExpressible {
    let content: Content
    
    init(@QueryBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    init(content: Content) {
        self.content = content
    }
    
    func serialize(to serializer: inout SQLSerializer) {
        content.querySqlExpression.serialize(to: &serializer)
    }
}

struct SubqueryModifier<Content>: QuerySQLExpressible where Content: QuerySQLExpressible {
    let name: String
    let content: Content
    
    struct Query: SQLExpression {
        let name: String
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("(")
            content.querySqlExpression.serialize(to: &serializer)
            serializer.write(")")
            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()
            serializer.writeQuote()
            serializer.write(name)
            serializer.writeQuote()
        }
    }
    
    var querySqlExpression: Query {
        .init(name: name, content: content)
    }
}

extension QueryDirective {
    func asSubquery<T>(_ table: T) -> QueryDirective<SubqueryModifier<Content>> where T: Table {
        .init(content: SubqueryModifier(name: type(of: table).schema, content: content))
    }
    
    func asSubquery<T>(_ alias: TableAlias<T>) -> QueryDirective<SubqueryModifier<Content>> where T: Table {
        .init(content: SubqueryModifier(name: alias.alias, content: content))
    }
    
    func asSubquery(_ name: String) -> QueryDirective<SubqueryModifier<Content>> {
        .init(content: SubqueryModifier(name: name, content: content))
    }
}

struct WithModifier<Content>: QuerySQLExpressible where Content: QuerySQLExpressible {
    let name: String
    let content: Content
    
    struct Query: SQLExpression {
        let name: String
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.writeQuote()
            serializer.write(name)
            serializer.writeQuote()
            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()
            serializer.write("(")
            content.querySqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
    
    var querySqlExpression: Query {
        .init(name: name, content: content)
    }
}

extension QueryDirective {
    func asWith<T>(_ table: T) -> QueryDirective<WithModifier<Content>> where T: Table {
        .init(content: WithModifier(name: type(of: table).schema, content: content))
    }
    
    func asWith<T>(_ alias: TableAlias<T>) -> QueryDirective<WithModifier<Content>> where T: Table {
        .init(content: WithModifier(name: alias.alias, content: content))
    }
    
    func asWith(_ name: String) -> QueryDirective<WithModifier<Content>> {
        .init(content: WithModifier(name: name, content: content))
    }
}

extension WithModifier: WithSQLExpressible {
    var withSqlExpression: Query { querySqlExpression }
}

extension QueryDirective: WithSQLExpressible where Content: WithSQLExpressible {
    struct With<Content>: SQLExpression where Content: WithSQLExpressible {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            content.withSqlExpression.serialize(to: &serializer)
        }
    }
    
    var withSqlExpression: With<Content> { .init(content: content) }
}
