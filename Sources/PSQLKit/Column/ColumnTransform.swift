import Foundation
import SQLKit

public struct ColumnTransform<T, U> where T: PSQLExpressible {
    let column: ColumnExpression<T>
}

extension ColumnTransform: TypeEquatable {
    public typealias CompareType = U
}

extension ColumnTransform: CompareSQLExpressible {
    public var compareSqlExpression: some SQLExpression { column.compareSqlExpression }
}
