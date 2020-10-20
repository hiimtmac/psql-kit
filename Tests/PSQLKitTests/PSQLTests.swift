import XCTest
@testable import PSQLKit
import FluentKit
import SQLKit

final class MyModel: Model, Table {
    static let schema = "my_model"
    
    @ID var id: UUID?
    @OptionalField(key: "name") var name: String?
    @Field(key: "title") var title: String
    @Field(key: "age") var age: Int
    
    init() {}
}

class PSQLTestCase: XCTestCase {
    var serializer = SQLSerializer(database: TestSQLDatabase())
}
