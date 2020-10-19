import Foundation
import PostgresKit
import SQLKit

extension Bool: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .boolean }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Bool: SelectSQLExpressible {
    var compareSqlExpression: Bool { self }
}

extension Bool: CompareSQLExpressible {
    var selectSqlExpression: PrimativeSelect<Bool> { .init(value: self) }
}
