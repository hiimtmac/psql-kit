import XCTest
@testable import PSQLKit
import FluentKit

final class AdvancedTests: PSQLTestCase {
    
    final class Pet: Model, Table {
        static let schema = "pet"
        
        @ID var id: UUID?
        @Field(key: "name") var name: String
        @Parent(key: "owner_id") var owner: Owner
        
        init() {}
    }
    
    final class Owner: Model, Table {
        static let schema = "owner"
        
        @ID var id: UUID?
        @Field(key: "name") var name: String
        @Field(key: "age") var age: Int
        @Field(key: "bday") var bday: Date
        
        init() {}
    }
    
    struct DateRange: Table {
        static let schema: String = "date_range"
        @Column(key: "date") var date: SimpleDate
        @Column(key: "age") var age: Int
    }
    
    func testExample() {
        let d1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 31).date!
        let d2 = DateComponents(calendar: .current, year: 2020, month: 07, day: 31).date!
        let r = DateRange.as("r")
        let dateCol = COLUMN<SimpleDate>("date")
        let p = Pet.as("p")
        let o = Owner.as("o")

        let query = QUERY {
            WITH {
                QUERY {
                    SELECT { dateCol }
                    FROM { GENERATE_SERIES(from: SimpleDate(d1), to: SimpleDate(d2), interval: "1 day") }
                    ORDERBY { dateCol }
                }
                .asWith(r) // access the results from this query using r.$...
                QUERY {
                    SELECT {
                        o.$id
                    }
                    .distinct()
                    FROM { p.table }
                    JOIN(o.table) {
//                        o.$id == p.$owner
                    }
                }
            }
        }
        query.serialize(to: &serializer)
        XCTAssertEqual(serializer.psql, #"WITH "r" AS (SELECT "date"::date FROM GENERATE_SERIES('2020-01-31', '2020-07-31', '1 day'::interval) ORDER BY "date")"#)
    }
    
    static var allTests = [
        ("testExample", testExample)
    ]
}
