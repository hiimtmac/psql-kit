import XCTest
@testable import PSQLKit
import FluentKit
import SQLKit
import PostgresKit

final class FluentModel: Model, Table {
    static let schema = "my_model"
    
    @ID var id: UUID?
    @OptionalField(key: "name") var name: String?
    @Field(key: "title") var title: String
    @Field(key: "age") var age: Int
    @Field(key: "birthday") var birthday: Date
    @Group(key: "pet") var pet: Pet
    
    init() {}
    
    final class Pet: Fields, TableObject {
        @Field(key: "name") var name: String
        @Field(key: "type") var type: String
        @Group(key: "info") var info: Info

        init() { }
        
        final class Info: Fields, TableObject {
            @Field(key: "name") var name: String

            init() { }
        }
    }
}

struct PSQLModel: Table {
    static let schema = "my_model"
    
    @Column(key: "id") var id: UUID?
    @OptionalColumn(key: "name") var name: String?
    @Column(key: "title") var title: String
    @Column(key: "age") var age: Int
    @Column(key: "birthday") var birthday: Date
    @NestedColumn(key: "pet") var pet: Pet
    
    init() {}
    
    struct Pet: TableObject {
        @Column(key: "name") var name: String
        @Column(key: "type") var type: String
        @NestedColumn(key: "info") var info: Info

        init() { }
        
        struct Info: TableObject {
            @Column(key: "name") var name: String

            init() { }
        }
    }
}

class PSQLTestCase: XCTestCase {
    var fluentSerializer = SQLSerializer(database: TestSQLDatabase())
    var psqlkitSerializer = SQLSerializer(database: TestSQLDatabase())
}
