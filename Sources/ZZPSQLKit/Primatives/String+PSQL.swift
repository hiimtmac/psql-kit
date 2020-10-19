import Foundation
import SQLKit
import PostgresKit

extension String: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .text }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("'")
        serializer.write("\(self)")
        serializer.write("'")
    }
}

extension String: SelectSQLExpressible {
    var compareSqlExpression: String { self }
}

extension String: CompareSQLExpressible {
    var selectSqlExpression: PrimativeSelect<String> { .init(value: self) }
}
