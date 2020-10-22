import XCTest
@testable import PSQLKit
import FluentKit
import SQLKit
import PostgresKit

final class MyModel: Model, Table {
    static let schema = "my_model"
    
    @ID var id: UUID?
    @OptionalField(key: "name") var name: String?
    @Field(key: "title") var title: String
    @Field(key: "age") var age: Int
    @Field(key: "json") var json: JsonObject
    
    init() {}
    
    struct JsonObject: Codable, PSQLExpressible {
        let name: String
        
        func serialize(to serializer: inout SQLSerializer) {
            //
        }
        
        typealias CompareType = Self
        static var postgresColumnType: PostgresColumnType { .json }
    }
}

class PSQLTestCase: XCTestCase {
    var serializer = SQLSerializer(database: TestSQLDatabase())
}
