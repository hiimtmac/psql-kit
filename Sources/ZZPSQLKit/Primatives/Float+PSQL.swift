import Foundation
import SQLKit
import PostgresKit

extension Float: PSQLExpressible {
    typealias CompareType = Self
    static var postgresColumnType: PostgresColumnType { .decimal }
    
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("\(self)")
    }
}

extension Float: SelectSQLExpressible {
    var compareSqlExpression: Float { self }
}

extension Float: CompareSQLExpressible {
    var selectSqlExpression: PrimativeSelect<Float> { .init(value: self) }
}
