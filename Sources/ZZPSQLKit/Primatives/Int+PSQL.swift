import Foundation
import SQLKit
import PostgresKit

extension Int: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .integer }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Int: SelectSQLExpressible {
    var compareSqlExpression: Int { self }
}

extension Int: CompareSQLExpressible {
    var selectSqlExpression: PrimativeSelect<Int> { .init(value: self) }
}
