import Foundation
import SQLKit

public protocol SelectSQLExpressible {
    associatedtype Select: SQLExpression
    var selectSqlExpression: Select { get }
}

public protocol FromSQLExpressible {
    associatedtype From: SQLExpression
    var fromSqlExpression: From { get }
}

public protocol GroupBySQLExpressible {
    associatedtype GroupBy: SQLExpression
    var groupBySqlExpression: GroupBy { get }
}

public protocol OrderBySQLExpressible {
    associatedtype OrderBy: SQLExpression
    var orderBySqlExpression: OrderBy { get }
}

public protocol CompareSQLExpressible {
    associatedtype Compare: SQLExpression
    var compareSqlExpression: Compare { get }
}

public protocol JoinSQLExpressible {
    associatedtype Join: SQLExpression
    var joinSqlExpression: Join { get }
}

public protocol WhereSQLExpressible {
    associatedtype Where: SQLExpression
    var whereSqlExpression: Where { get }
}

public protocol HavingSQLExpressible {
    associatedtype Having: SQLExpression
    var havingSqlExpression: Having { get }
}

public protocol QuerySQLExpressible {
    associatedtype Query: SQLExpression
    var querySqlExpression: Query { get }
}

public protocol WithSQLExpressible {
    associatedtype With: SQLExpression
    var withSqlExpression: With { get }
}

public protocol UnionSQLExpressible {
    associatedtype Union: SQLExpression
    var unionSqlExpression: Union { get }
}
