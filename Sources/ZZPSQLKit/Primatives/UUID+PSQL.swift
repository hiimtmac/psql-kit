import Foundation
import SQLKit
import PostgresKit

extension UUID: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .uuid }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("'")
        serializer.write("\(self)")
        serializer.write("'")
    }
}

extension UUID: SelectSQLExpressible {
    var compareSqlExpression: UUID { self }
}

extension UUID: CompareSQLExpressible {
    var selectSqlExpression: PrimativeSelect<UUID> { .init(value: self) }
}
