import Foundation
import SQLKit
import PostgresKit

extension Float: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .decimal }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Float: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { PrimativeSelect(value: self) }
}

extension Float: CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression { self }
}
