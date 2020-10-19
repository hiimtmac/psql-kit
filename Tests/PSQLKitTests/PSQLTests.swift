import XCTest
@testable import PSQLKit
import FluentKit
import PostgresKit
import SQLKit
import NIO

final class MyModel: Model, Table {
    static let schema = "my_model"
    
    @ID var id: UUID?
    @OptionalField(key: "name") var name: String?
    @Field(key: "title") var title: String
    @Field(key: "age") var age: Int
    
    init() {}
}

class PSQLTestCase: XCTestCase {
    var serializer = SQLSerializer(database: TestDatabase())
}

final class TestDatabase: SQLDatabase {
    let logger: Logger
    let eventLoop: EventLoop
    var results: [String]
    let dialect: SQLDialect = PostgresDialect()
    
    init() {
        self.logger = .init(label: "codes.vapor.sql.test")
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
