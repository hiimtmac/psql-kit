import Foundation
import FluentKit
import PostgresKit
import SQLKit
import NIO

extension SQLExpression {
    public func raw(database: SQLDatabase = Self.testDB) -> (sql: String, binds: [Encodable]) {
        var serializer = SQLSerializer(database: database)
        self.serialize(to: &serializer)
        return (serializer.sql, serializer.binds)
    }
    
    public static var testDB: SQLDatabase { TestSQLDatabase() }
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
