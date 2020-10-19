import Foundation
import PostgresKit
import SQLKit

extension Double: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .decimal }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Double: SelectSQLExpressible {
    var compareSqlExpression: Double { self }
}

extension Double: CompareSQLExpressible {
    var selectSqlExpression: PrimativeSelect<Double> { .init(value: self) }
}
