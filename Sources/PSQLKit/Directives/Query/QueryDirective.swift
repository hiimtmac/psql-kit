import Foundation
import SQLKit

public struct QueryDirective<Content>: SQLExpression where Content: QuerySQLExpressible {
    let content: Content
    
    public init(@QueryBuilder builder: () -> Content) {
        self.content = builder()
    }
    
    init(content: Content) {
        self.content = content
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        content.querySqlExpression.serialize(to: &serializer)
    }
}

public struct SubqueryModifier<Content>: QuerySQLExpressible where Content: QuerySQLExpressible {
    let name: String
    let content: Content
    
    private struct _Query: SQLExpression {
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
    
    public var querySqlExpression: some SQLExpression {
        _Query(name: name, content: content)
    }
}

extension QueryDirective {
    public func asSubquery<T>(_ table: T) -> QueryDirective<SubqueryModifier<Content>> where T: Table {
        .init(content: SubqueryModifier(name: type(of: table).schema, content: content))
    }
    
    public func asSubquery<T>(_ alias: TableAlias<T>) -> QueryDirective<SubqueryModifier<Content>> where T: Table {
        .init(content: SubqueryModifier(name: alias.alias, content: content))
    }
    
    public func asSubquery(_ name: String) -> QueryDirective<SubqueryModifier<Content>> {
        .init(content: SubqueryModifier(name: name, content: content))
    }
}

public struct WithModifier<Content>: QuerySQLExpressible where Content: QuerySQLExpressible {
    let name: String
    let content: Content
    
    private struct _Query: SQLExpression {
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
    
    public var querySqlExpression: some SQLExpression {
        _Query(name: name, content: content)
    }
}

extension QueryDirective {
    public func asWith<T>(_ table: T) -> QueryDirective<WithModifier<Content>> where T: Table {
        .init(content: WithModifier(name: type(of: table).schema, content: content))
    }
    
    public func asWith<T>(_ alias: TableAlias<T>) -> QueryDirective<WithModifier<Content>> where T: Table {
        .init(content: WithModifier(name: alias.alias, content: content))
    }
    
    public func asWith(_ name: String) -> QueryDirective<WithModifier<Content>> {
        .init(content: WithModifier(name: name, content: content))
    }
}

extension WithModifier: WithSQLExpressible {
    public var withSqlExpression: Query { querySqlExpression }
}

extension QueryDirective: WithSQLExpressible where Content: WithSQLExpressible {
    struct With<Content>: SQLExpression where Content: WithSQLExpressible {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            content.withSqlExpression.serialize(to: &serializer)
        }
    }
    
    public var withSqlExpression: some SQLExpression { With(content: content) }
}
