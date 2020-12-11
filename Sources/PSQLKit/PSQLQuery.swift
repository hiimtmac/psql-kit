import Foundation
import SQLKit
import FluentKit
import NIO
import PostgresKit

public protocol PSQLQuery: SQLExpression, QuerySQLExpression { }

extension QueryDirective: PSQLQuery {
    public var querySqlExpression: some SQLExpression { self }
}

extension PSQLQuery {
    public func raw(database: SQLDatabase = Self.testDB) -> (sql: String, binds: [Encodable]) {
        var serializer = SQLSerializer(database: database)
        self.serialize(to: &serializer)
        return (serializer.sql, serializer.binds)
    }
    
    public static var testDB: SQLDatabase { TestSQLDatabase() }
    
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

public final class PSQLQueryFetcher: SQLQueryFetcher {
    public var query: SQLExpression
    public var database: SQLDatabase
    
    init(query: SQLExpression, database: SQLDatabase) {
        self.query = query
        self.database = database
    }
}

final class TestSQLDatabase: SQLDatabase {
    let logger: Logger
    let eventLoop: EventLoop
    var results: [String]
    let dialect: SQLDialect = PostgresDialect()
    
    init() {
        self.logger = .init(label: "com.hiimtmac.psqlkit")
        self.eventLoop = EmbeddedEventLoop()
        self.results = []
    }
    
    func execute(sql query: SQLExpression, _ onRow: @escaping (SQLRow) -> ()) -> EventLoopFuture<Void> {
        var serializer = SQLSerializer(database: self)
        query.serialize(to: &serializer)
        results.append(serializer.sql)
        return self.eventLoop.makeSucceededFuture(())
    }
}
