import XCTest
@testable import PSQLKit
import FluentKit

final class MyModel: Model, Table {
    static let schema = "my_model"
    
    @ID var id: UUID?
    @Field(key: "name") var name: String
    
    init() {}
}

class PSQLTestCase: XCTestCase {
    var serializer = PSQLSerializer()
}
