import Foundation
import PostgresKit
import SQLKit

extension Bool: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .boolean }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Bool: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { PrimativeSelect(value: self) }
}

extension Bool: CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression { self }
}

extension Bool: JoinSQLExpressible {
    public var joinSqlExpression: some SQLExpression { self }
}
