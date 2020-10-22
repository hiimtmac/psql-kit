import Foundation
import SQLKit
import PostgresKit

extension Int: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .integer }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Int: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { PrimativeSelect(value: self) }
}

extension Int: CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression { self }
}
