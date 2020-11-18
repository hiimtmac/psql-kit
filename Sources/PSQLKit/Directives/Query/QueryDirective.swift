import Foundation
import SQLKit

public struct QueryDirective<Content>: SQLExpression where Content: QuerySQLExpression {
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

extension QueryDirective: UnionSQLExpression {
    public var unionSqlExpression: some SQLExpression { self }
}

// MARK: - SubqueryModifier
public struct SubqueryModifier<Content> where Content: QuerySQLExpression {
    let name: String
    let content: Content
}

extension SubqueryModifier: QuerySQLExpression {
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

extension SubqueryModifier: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression { querySqlExpression }
}

extension QueryDirective: FromSQLExpression where Content: FromSQLExpression {
    private struct _From<Content>: SQLExpression where Content: FromSQLExpression {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            content.fromSqlExpression.serialize(to: &serializer)
        }
    }
    
    public var fromSqlExpression: some SQLExpression {
        _From(content: content)
    }
}

extension SubqueryModifier: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { querySqlExpression }
}

extension QueryDirective: SelectSQLExpression where Content: SelectSQLExpression {
    private struct _Select<Content>: SQLExpression where Content: SelectSQLExpression {
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
public struct WithModifier<Content> where Content: QuerySQLExpression {
    let name: String
    let content: Content
}

extension WithModifier: QuerySQLExpression {
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

extension WithModifier: WithSQLExpression {
    public var withSqlExpression: some SQLExpression { querySqlExpression }
}

extension QueryDirective: WithSQLExpression where Content: WithSQLExpression {
    private struct _With<Content>: SQLExpression where Content: WithSQLExpression {
        let content: Content
        
        func serialize(to serializer: inout SQLSerializer) {
            content.withSqlExpression.serialize(to: &serializer)
        }
    }
    
    public var withSqlExpression: some SQLExpression {
        _With(content: content)
    }
}
