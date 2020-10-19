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

protocol CompareSQLExpressible {
    associatedtype Compare: SQLExpression
    var compareSqlExpression: Compare { get }
}

protocol JoinSQLExpressible {
    associatedtype Join: SQLExpression
    var joinSqlExpression: Join { get }
}

protocol WhereSQLExpressible {
    associatedtype Where: SQLExpression
    var whereSqlExpression: Where { get }
}

protocol HavingSQLExpressible {
    associatedtype Having: SQLExpression
    var havingSqlExpression: Having { get }
}

protocol QuerySQLExpressible {
    associatedtype Query: SQLExpression
    var querySqlExpression: Query { get }
}

protocol WithSQLExpressible {
    associatedtype With: SQLExpression
    var withSqlExpression: With { get }
}
