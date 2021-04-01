import Foundation
import SQLKit
import PostgresKit

public protocol PSQLQuery: SQLExpression, QuerySQLExpression { }

extension PSQLQuery {
    #if DEBUG
    public func raw(database: SQLDatabase = Self.testDB) -> (sql: String, binds: [Encodable]) {
        var serializer = SQLSerializer(database: database)
        self.serialize(to: &serializer)
        return (serializer.sql, serializer.binds)
    }
    
    public static var testDB: SQLDatabase { TestSQLDatabase() }
    #endif
    
    public func execute(on database: Database) -> PSQLQueryFetcher {
        let psqlDatabase = database as! PostgresDatabase
        let sqlDatabase = psqlDatabase.sql()
        
        return PSQLQueryFetcher(query: self, database: sqlDatabase)
    }
    
    public func asWith<T>(_ table: T) -> QueryDirective<WithModifier<Self>> where T: Table {
        .init(content: WithModifier(name: type(of: table).schema, content: self))
    }
    
    public func asWith<T>(_ alias: TableAlias<T>) -> QueryDirective<WithModifier<Self>> where T: Table {
        .init(content: WithModifier(name: alias.alias, content: self))
    }
    
    public func asWith(_ name: String) -> QueryDirective<WithModifier<Self>> {
        .init(content: WithModifier(name: name, content: self))
    }
}

extension QueryDirective: PSQLQuery {
    public var querySqlExpression: some SQLExpression { self }
}
