import XCTest
@testable import PSQLKit
import FluentKit

final class FluentTests: PSQLTestCase {
    final class Pet: Model, Table {
        static let schema = "pet"
        
        @ID var id: UUID?
        @Field(key: "name") var name: String
        @Parent(key: "owner_id") var owner: Owner
        
        init() {}
    }
    
    final class Thing: Model, Table {
        static let schema = "pet"
        
        @ID var id: UUID?
        @Field(key: "name") var name: String
        @OptionalParent(key: "parent_id") var parent: Owner?
        
        init() {}
    }
    
    final class Owner: Model, Table {
        static let schema = "owner"
        
        @ID var id: UUID?
        @Field(key: "name") var name: String
        @Field(key: "age") var age: Int
        @Field(key: "bday") var bday: PSQLDate
        
        init() {}
    }

    func testRelationships() {
        let p = Pet.as("p")
        let o = Owner.as("o")
        let t = Thing.as("t")
        
        let b = WHERE {
            p.$owner == o.$id
            t.$parent == o.$id
            Pet.$owner == Owner.$id
            Thing.$parent == Owner.$id
            p.$owner == Owner.$id
            t.$parent == Owner.$id
        }
        
        b.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"WHERE ("p"."owner_id" = "o"."id") AND ("t"."parent_id" = "o"."id") AND ("pet"."owner_id" = "owner"."id") AND ("pet"."parent_id" = "owner"."id") AND ("p"."owner_id" = "owner"."id") AND ("t"."parent_id" = "owner"."id")"#)
    }
    
    static var allTests = [
        ("testRelationships", testRelationships)
    ]
}
