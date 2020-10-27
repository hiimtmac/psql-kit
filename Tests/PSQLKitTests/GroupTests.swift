import XCTest
@testable import PSQLKit
import FluentKit

final class GroupTests: PSQLTestCase {
    func testGroups() {
        QUERY {
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
        .serialize(to: &fluentSerializer)
        
        QUERY {
            SELECT {
                PSQLModel.$id
                
                SELECTGROUP {
                    PSQLModel.$id
                    PSQLModel.$age
                }
                SELECTGROUP {
                    PSQLModel.$id
                    PSQLModel.$age
                }
            }
            FROM {
                PSQLModel.table
                FROMGROUP {
                    PSQLModel.table
                    PSQLModel.table
                }
            }
            JOIN(PSQLModel.table) { true }
            QUERYGROUP {
                JOIN(PSQLModel.table) { true }
                JOIN(PSQLModel.table) {
                    JOINGROUP {
                        true
                        true
                    }
                }
            }
            WHERE {
                PSQLModel.$id == PSQLModel.$id
                
                WHEREGROUP {
                    PSQLModel.$id == PSQLModel.$id
                    PSQLModel.$id == PSQLModel.$id
                }
            }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "my_model"."id"::UUID, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."id"::UUID, "my_model"."age"::INTEGER FROM "my_model", "my_model", "my_model" INNER JOIN "my_model" ON true INNER JOIN "my_model" ON true INNER JOIN "my_model" ON true AND true WHERE ("my_model"."id" = "my_model"."id") AND ("my_model"."id" = "my_model"."id") AND ("my_model"."id" = "my_model"."id")"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    func testLength() {
        SELECT {
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
        .serialize(to: &fluentSerializer)
        
        SELECT {
            SELECTGROUP {
                PSQLModel.$id
                PSQLModel.$age
                PSQLModel.$name
                PSQLModel.$id
                PSQLModel.$age
                PSQLModel.$name
                PSQLModel.$id
                PSQLModel.$age
            }

            SELECTGROUP {
                PSQLModel.$id
                PSQLModel.$age
                PSQLModel.$name
                PSQLModel.$id
                PSQLModel.$age
                PSQLModel.$name
                PSQLModel.$id
                PSQLModel.$age
            }
        }
        .serialize(to: &psqlkitSerializer)
        
        let compare = #"SELECT "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER, "my_model"."name"::TEXT, "my_model"."id"::UUID, "my_model"."age"::INTEGER"#
        XCTAssertEqual(fluentSerializer.sql, compare)
        XCTAssertEqual(psqlkitSerializer.sql, compare)
    }
    
    static var allTests = [
        ("testGroups", testGroups),
        ("testLength", testLength),
    ]
}
