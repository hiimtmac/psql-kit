import XCTest
@testable import PSQLKit
import FluentKit

final class FluentTests: PSQLTestCase {
    final class Pet: Model, Table {
        static let schema = "pet"
        
        @ID var id: UUID?
        @Field(key: "name") var name: String
        @Parent(key: "owner_id") var owner: Owner
        @Timestamp(key: "created_at", on: .create) var createdAt: Date?
        
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
        
        let b = QUERY {
            SELECT {
                p.$owner
                Pet.$owner
            }
            WHERE {
                p.$owner == o.$id
                t.$parent == o.$id
                Pet.$owner == Owner.$id
                Thing.$parent == Owner.$id
                p.$owner == Owner.$id
                t.$parent == Owner.$id
            }
            GROUPBY {
                p.$owner
                Pet.$owner
                Thing.$parent
                t.$parent
            }
        }
        
        b.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT "p"."owner_id"::UUID, "pet"."owner_id"::UUID WHERE ("p"."owner_id" = "o"."id") AND ("t"."parent_id" = "o"."id") AND ("pet"."owner_id" = "owner"."id") AND ("pet"."parent_id" = "owner"."id") AND ("p"."owner_id" = "owner"."id") AND ("t"."parent_id" = "owner"."id") GROUP BY "p"."owner_id", "pet"."owner_id", "pet"."parent_id", "t"."parent_id""#)
    }
    
    func testDates() {
        let p = Pet.as("p")
        let date1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 01).date!.psqlDate
        let date2 = DateComponents(calendar: .current, year: 2020, month: 01, day: 30).date!.psqlDate
        
        let b = QUERY {
            SELECT {
                Pet.$createdAt
                p.$createdAt
            }
            WHERE {
                p.$createdAt.transform(to: PSQLDate.self) >< PSQLRange(from: date1, to: date2)
            }
            GROUPBY {
                p.$createdAt
            }
        }
        
        b.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT "pet"."created_at"::TIMESTAMP, "p"."created_at"::TIMESTAMP WHERE ("p"."created_at" BETWEEN '2020-01-01'::DATE AND '2020-01-30'::DATE) GROUP BY "p"."created_at""#)
    }
    
    static var allTests = [
        ("testRelationships", testRelationships)
    ]
}
