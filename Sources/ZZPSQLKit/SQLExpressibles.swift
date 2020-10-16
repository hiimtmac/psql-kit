import Foundation
import SQLKit

protocol SelectSQLExpressible {
    associatedtype Select: SQLExpression
    var selectSqlExpression: Select { get }
}

protocol FromSQLExpressible {
    associatedtype From: SQLExpression
    var fromSqlExpression: From { get }
}

protocol GroupBySQLExpressible {
    associatedtype GroupBy: SQLExpression
    var groupBySqlExpression: GroupBy { get }
}

protocol OrderBySQLExpressible {
    associatedtype OrderBy: SQLExpression
    var orderBySqlExpression: OrderBy { get }
}
