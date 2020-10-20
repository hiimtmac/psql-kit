import Foundation
import SQLKit
import FluentKit
import NIO
import PostgresKit

public protocol PSQLQuery: SQLExpression { }

extension QueryDirective: PSQLQuery { }

extension PSQLQuery {
    public func raw(database: SQLDatabase = Self.testDB) -> (sql: String, binds: [Encodable]) {
        var serializer = SQLSerializer(database: database)
        self.serialize(to: &serializer)
        return (serializer.sql, serializer.binds)
    }
    
    public static var testDB: SQLDatabase { TestSQLDatabase() }
    
    public func query(on database: Database) -> PSQLQueryFetcher {
        let psqlDatabase = database as! PostgresDatabase
        let sqlDatabase = psqlDatabase.sql()
        
        return PSQLQueryFetcher(query: self, database: sqlDatabase)
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
