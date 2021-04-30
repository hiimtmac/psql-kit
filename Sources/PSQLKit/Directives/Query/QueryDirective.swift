import Foundation
import SQLKit

public struct QueryDirective: SQLExpression {
    let content: [QuerySQLExpression]
    
    public init(@QueryBuilder builder: () -> [QuerySQLExpression]) {
        self.content = builder()
    }
    
    init(content: [QuerySQLExpression]) {
        self.content = content
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        SQLList(content.map(\.querySqlExpression), separator: SQLRaw(" "))
            .serialize(to: &serializer)
    }
}

extension QueryDirective: UnionSQLExpression {
    public var unionSqlExpression: SQLExpression { self }
}

// MARK: - SubqueryModifier
public struct SubQuery: SQLExpression {
    let name: String
    let content: [QuerySQLExpression]
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("(")
        SQLList(content.map(\.querySqlExpression), separator: SQLRaw(" "))
            .serialize(to: &serializer)
        serializer.write(")")
        serializer.writeSpace()
        serializer.write("AS")
        serializer.writeSpace()
        serializer.writeQuote()
        serializer.write(name)
        serializer.writeQuote()
    }
}

extension QueryDirective {
    public func asSubquery<T>(_ table: T) -> SubQuery where T: Table {
        SubQuery(name: type(of: table).schema, content: content)
    }
    
    public func asSubquery<T>(_ alias: TableAlias<T>) -> SubQuery where T: Table {
        SubQuery(name: alias.alias, content: content)
    }
    
    public func asSubquery(_ name: String) -> SubQuery {
        SubQuery(name: name, content: content)
    }
}

extension SubQuery: FromSQLExpression {
    public var fromSqlExpression: SQLExpression { self }
}

extension QueryDirective: FromSQLExpression {
    private struct _From: SQLExpression {
        let content: [QuerySQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(content.map(\.querySqlExpression), separator: SQLRaw(" "))
                .serialize(to: &serializer)
        }
    }
    
    public var fromSqlExpression: SQLExpression {
        _From(content: content)
    }
}

extension SubQuery: SelectSQLExpression {
    public var selectSqlExpression: SQLExpression { self }
}

extension QueryDirective: SelectSQLExpression {
    private struct _Select: SQLExpression {
        let content: [QuerySQLExpression]
        
        func serialize(to serializer: inout SQLSerializer) {
            SQLList(content.map(\.querySqlExpression), separator: SQLRaw(" "))
                .serialize(to: &serializer)
        }
    }
    
    public var selectSqlExpression: SQLExpression {
        _Select(content: content)
    }
}

// MARK: - WithModifier
public struct WithQuery: SQLExpression {
    let name: String
    let content: [QuerySQLExpression]
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.writeQuote()
        serializer.write(name)
        serializer.writeQuote()
        serializer.writeSpace()
        serializer.write("AS")
        serializer.writeSpace()
        serializer.write("(")
        SQLList(content.map(\.querySqlExpression), separator: SQLRaw(" "))
            .serialize(to: &serializer)
        serializer.write(")")
    }
}

extension QueryDirective {
    public func asWith<T>(_ table: T) -> WithQuery where T: Table {
        WithQuery(name: type(of: table).schema, content: content)
    }
    
    public func asWith<T>(_ alias: TableAlias<T>) -> WithQuery where T: Table {
        WithQuery(name: alias.alias, content: content)
    }
    
    public func asWith(_ name: String) -> WithQuery {
        WithQuery(name: name, content: content)
    }
}

extension WithQuery: WithSQLExpression {
    public var withSqlExpression: SQLExpression { self }
}

extension QueryDirective: WithSQLExpression {
    private struct _With: SQLExpression {
        let content: [QuerySQLExpression]

        func serialize(to serializer: inout SQLSerializer) {
            SQLList(content.map(\.querySqlExpression), separator: SQLRaw(" "))
                .serialize(to: &serializer)
        }
    }

    public var withSqlExpression: SQLExpression {
        _With(content: content)
    }
}
