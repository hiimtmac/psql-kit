import Foundation
import PostgresKit

public protocol TableObject: PSQLExpression {
    init()
}

extension TableObject {
    public static var postgresColumnType: PostgresColumnType { .jsonb }
    public typealias Column<Value> = ColumnProperty<Self, Value> where Value: Codable
    public typealias OptionalColumn<Value> = OptionalColumnProperty<Self, Value> where Value: Codable
    public typealias NestedColumn<Value> = NestedObjectProperty<Self, Value> where Value: Codable
}
