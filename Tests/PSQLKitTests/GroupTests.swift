import XCTest
@testable import PSQLKit
import FluentKit

final class GroupTests: PSQLTestCase {
    let m = MyModel.as("x")
    
    func testGroups() {
        let q = QUERY {
            SELECT {
                MyModel.$id
                
                SELECTGROUP {
                    MyModel.$id
                    MyModel.$age
                }
                SELECTGROUP {
                    MyModel.$id
                    MyModel.$age
                }
            }
            FROM {
                MyModel.table
                FROMGROUP {
                    MyModel.table
                    MyModel.table
                }
            }
            JOIN(MyModel.table) { true }
            QUERYGROUP {
                JOIN(MyModel.table) { true }
                JOIN(MyModel.table) {
                    JOINGROUP {
                        true
                        true
                    }
                }
            }
            WHERE {
                MyModel.$id == MyModel.$id
                
                WHEREGROUP {
                    MyModel.$id == MyModel.$id
                    MyModel.$id == MyModel.$id
                }
            }
        }
        
        q.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT "my_model"."id"::UUID, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."id"::UUID, "my_model"."age"::INTEGER FROM "my_model", "my_model", "my_model" INNER JOIN "my_model" ON true INNER JOIN "my_model" ON true INNER JOIN "my_model" ON true AND true WHERE ("my_model"."id" = "my_model"."id") AND ("my_model"."id" = "my_model"."id") AND ("my_model"."id" = "my_model"."id")"#)
    }
    
    func testLength() {
        let w = SELECT {
            SELECTGROUP {
                MyModel.$id
                MyModel.$age
                MyModel.$name
                MyModel.$id
                MyModel.$age
                MyModel.$name
                MyModel.$id
                MyModel.$age
            }

            SELECTGROUP {
                MyModel.$id
                MyModel.$age
                MyModel.$name
                MyModel.$id
                MyModel.$age
                MyModel.$name
                MyModel.$id
                MyModel.$age
            }
        }
        
        w.serialize(to: &serializer)
        XCTAssertEqual(serializer.sql, #"SELECT "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER"#)
    }
    
    static var allTests = [
        ("testGroups", testGroups),
        ("testLength", testLength),
    ]
}
