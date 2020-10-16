import XCTest
@testable import ZZPSQLKit
import FluentKit
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
    var dialect: SQLDialect {
        self._dialect
    }
    var _dialect: GenericDialect
    
    init() {
        self.logger = .init(label: "codes.vapor.sql.test")
        self.eventLoop = EmbeddedEventLoop()
        self.results = []
        self._dialect = GenericDialect()
    }
    
    func execute(sql query: SQLExpression, _ onRow: @escaping (SQLRow) -> ()) -> EventLoopFuture<Void> {
        var serializer = SQLSerializer(database: self)
        query.serialize(to: &serializer)
        results.append(serializer.sql)
        return self.eventLoop.makeSucceededFuture(())
    }
}

struct GenericDialect: SQLDialect {
    var supportsAutoIncrement: Bool = true

    var name: String = "generic sql"
    
    var supportsIfExists: Bool = true

    var supportsReturning: Bool = true

    var identifierQuote: SQLExpression {
        return SQLRaw("`")
    }
    
    var literalStringQuote: SQLExpression {
        return SQLRaw("'")
    }
    
    func bindPlaceholder(at position: Int) -> SQLExpression {
        return SQLRaw("?")
    }
    
    func literalBoolean(_ value: Bool) -> SQLExpression {
        switch value {
        case true: return SQLRaw("true")
        case false: return SQLRaw("false")
        }
    }

    var enumSyntax: SQLEnumSyntax = .inline
    
    var autoIncrementClause: SQLExpression {
        return SQLRaw("AUTOINCREMENT")
    }

    var autoIncrementFunction: SQLExpression? = nil

    var supportsDropBehavior: Bool = false

    var triggerSyntax = SQLTriggerSyntax()

    var alterTableSyntax = SQLAlterTableSyntax(alterColumnDefinitionClause: SQLRaw("MODIFY"), alterColumnDefinitionTypeKeyword: nil)

    mutating func setTriggerSyntax(create: SQLTriggerSyntax.Create = [], drop: SQLTriggerSyntax.Drop = []) {
        self.triggerSyntax.create = create
        self.triggerSyntax.drop = drop
    }
}
