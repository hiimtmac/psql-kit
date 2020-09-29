import XCTest
@testable import PSQLKit
import FluentKit

final class AdvancedTests: PSQLTestCase {
    
//    final class Pet: Model, Table {
//        static let schema = "pet"
//        
//        @ID var id: UUID?
//        @Field(key: "name") var name: String
//        @Parent(key: "owner_id") var owner: Owner
//        
//        init() {}
//    }
//    
//    final class Owner: Model, Table {
//        static let schema = "owner"
//        
//        @ID var id: UUID?
//        @Field(key: "name") var name: String
//        @Field(key: "age") var age: Int
//        @Field(key: "bday") var bday: Date
//        
//        init() {}
//    }
//    
//    struct DateRange: Table {
//        static let schema: String = "date_range"
//        @Column(key: "date") var date: Date
//    }
//    
//    struct OwnerFilter: Table {
//        @Column(key: "id") var id: UUID
//    }
//    
//    struct OwnerDateSeries: Table {
//        @Column(key: "id") var id: UUID?
//        @Column(key: "date") var date: Date
//    }
//    
//    func testExample() {
//        let d1 = DateComponents(calendar: .current, year: 2020, month: 01, day: 31).date!
//        let d2 = DateComponents(calendar: .current, year: 2020, month: 07, day: 31).date!
//        let r = DateRange.as("r")
//        let dateCol = COLUMN<SimpleDate>("date")
//        let p = Pet.as("p")
//        let o = Owner.as("o")
//        let f = OwnerFilter.as("f")
//        
//        let query = QUERY {
//            WITH {
//                QUERY {
//                    SELECT { dateCol }
//                    FROM { GENERATE_SERIES(from: d1.simple, to: d2.simple, interval: "1 day") }
//                    ORDERBY { dateCol }
//                }
//                .asWith(r.with) // access the results from this query using r.$...
//                QUERY {
//                    SELECT { o.$id }.distinct()
//                    FROM { p.table }
//                    JOIN(o.table) { o.$id == p.$owner }
//                    WHERE {
//                        o.$age > 20
//                        p.$name == "dog"
//                    }
//                }
//                .asWith(f.with) // access the results from this query using f.$...
//                QUERY {
//                    SELECT {
//                        r.$date
//                        f.$id
//                    }
//                    FROM { f.table }
//                    JOIN(r.table) { 1 == 1 }
//                }
//                .asWith(OwnerDateSeries.with) // not using alias to access results with full type...
//            }
//            
//            SELECT {
//                OwnerDateSeries.$date
//                o.$name
//            }
//            FROM { f.table }
//            JOIN(o.table, type: .left) { f.$id == o.$id }
//            JOIN(OwnerDateSeries.table) { o.$bday.simple == OwnerDateSeries.$date.simple }
//        }
//        query.serialize(to: &serializer)
//        XCTAssertEqual(serializer.psql, #"WITH "r" AS (SELECT "date"::date FROM GENERATE_SERIES('2020-01-31', '2020-07-31', '1 day'::interval) ORDER BY "date"), "f" AS (SELECT DISTINCT "o"."id"::uuid FROM "pet" AS "p" INNER JOIN "owner" AS "o" ON ("o"."id"="p"."owner_id") WHERE ("o"."age">20) AND ("p"."name"='dog')), "OwnerDateSeries" AS (SELECT "r"."date"::date, "f"."id"::uuid FROM "OwnerFilter" AS "f" INNER JOIN "date_range" AS "r" ON (1=1)) SELECT "OwnerDateSeries"."date"::date, "o"."name"::text FROM "OwnerFilter" AS "f" LEFT JOIN "owner" AS "o" ON ("f"."id"="o"."id") INNER JOIN "OwnerDateSeries" ON ("o"."bday"="OwnerDateSeries"."date")"#)
//    }
//    
//    static var allTests = [
//        ("testExample", testExample)
//    ]
}
