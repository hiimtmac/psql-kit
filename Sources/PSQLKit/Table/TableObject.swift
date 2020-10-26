import Foundation
import PostgresKit

public protocol TableObject: PSQLExpression {
    init()
}

extension TableObject {
    public static var postgresColumnType: PostgresColumnType { .jsonb }
}
