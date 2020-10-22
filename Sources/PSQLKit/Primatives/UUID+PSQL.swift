import Foundation
import SQLKit
import PostgresKit

extension UUID: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .uuid }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("'")
        serializer.write("\(self)")
        serializer.write("'")
    }
}

extension UUID: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { PrimativeSelect(value: self) }
}

extension UUID: CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression { self }
}
