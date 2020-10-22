import Foundation
import PostgresKit
import SQLKit

extension Double: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .decimal }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Double: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { PrimativeSelect(value: self) }
}

extension Double: CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression { self }
}
