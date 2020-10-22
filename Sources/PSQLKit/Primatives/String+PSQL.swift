import Foundation
import SQLKit
import PostgresKit

extension String: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .text }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("'")
        serializer.write("\(self)")
        serializer.write("'")
    }
}

extension String: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { PrimativeSelect(value: self) }
}

extension String: CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression { self }
}
