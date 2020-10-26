import XCTest
@testable import PSQLKit
import FluentKit

final class GroupTests: PSQLTestCase {
    let m = FluentModel.as("x")
    
    func testGroups() {
        let q = QUERY {
            SELECT {
                FluentModel.$id
                
                SELECTGROUP {
                    FluentModel.$id
                    FluentModel.$age
                }
                SELECTGROUP {
                    FluentModel.$id
                    FluentModel.$age
                }
            }
            FROM {
                FluentModel.table
                FROMGROUP {
                    FluentModel.table
                    FluentModel.table
                }
            }
            JOIN(FluentModel.table) { true }
            QUERYGROUP {
                JOIN(FluentModel.table) { true }
                JOIN(FluentModel.table) {
                    JOINGROUP {
                        true
                        true
                    }
                }
            }
            WHERE {
                FluentModel.$id == FluentModel.$id
                
                WHEREGROUP {
                    FluentModel.$id == FluentModel.$id
                    FluentModel.$id == FluentModel.$id
                }
            }
        }
        
        q.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT "my_model"."id"::UUID, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."id"::UUID, "my_model"."age"::INTEGER FROM "my_model", "my_model", "my_model" INNER JOIN "my_model" ON true INNER JOIN "my_model" ON true INNER JOIN "my_model" ON true AND true WHERE ("my_model"."id" = "my_model"."id") AND ("my_model"."id" = "my_model"."id") AND ("my_model"."id" = "my_model"."id")"#)
    }
    
    func testLength() {
        let w = SELECT {
            SELECTGROUP {
                FluentModel.$id
                FluentModel.$age
                FluentModel.$name
                FluentModel.$id
                FluentModel.$age
                FluentModel.$name
                FluentModel.$id
                FluentModel.$age
            }

            SELECTGROUP {
                FluentModel.$id
                FluentModel.$age
                FluentModel.$name
                FluentModel.$id
                FluentModel.$age
                FluentModel.$name
                FluentModel.$id
                FluentModel.$age
            }
        }
        
        w.serialize(to: &fluentSerializer)
        XCTAssertEqual(fluentSerializer.sql, #"SELECT "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER"#)
    }
    
    static var allTests = [
        ("testGroups", testGroups),
        ("testLength", testLength),
    ]
}
