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

extension QueryDirective: UnionSQLExpressible {
    public var unionSqlExpression: some SQLExpression { self }
}

// MARK: - SubqueryModifier
public struct SubqueryModifier<Content> where Content: QuerySQLExpressible {
    let name: String
    let content: Content
}

extension SubqueryModifier: QuerySQLExpressible {
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

extension SubqueryModifier: FromSQLExpressible {
    public var fromSqlExpression: some SQLExpression { querySqlExpression }
}

extension QueryDirective: FromSQLExpressible where Content: FromSQLExpressible {
    private struct _From<Content>: SQLExpression where Content: FromSQLExpressible {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            content.fromSqlExpression.serialize(to: &serializer)
        }
    }
    
    public var fromSqlExpression: some SQLExpression {
        _From(content: content)
    }
}

extension SubqueryModifier: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { querySqlExpression }
}

extension QueryDirective: SelectSQLExpressible where Content: SelectSQLExpressible {
    private struct _Select<Content>: SQLExpression where Content: SelectSQLExpressible {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            content.selectSqlExpression.serialize(to: &serializer)
        }
    }
    
    public var selectSqlExpression: some SQLExpression {
        _Select(content: content)
    }
}

// MARK: - WithModifier
public struct WithModifier<Content> where Content: QuerySQLExpressible {
    let name: String
    let content: Content
}

extension WithModifier: QuerySQLExpressible {
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
    public var withSqlExpression: some SQLExpression { querySqlExpression }
}

extension QueryDirective: WithSQLExpressible where Content: WithSQLExpressible {
    private struct _With<Content>: SQLExpression where Content: WithSQLExpressible {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            content.withSqlExpression.serialize(to: &serializer)
        }
    }
    
    public var withSqlExpression: some SQLExpression {
        _With(content: content)
    }
}
