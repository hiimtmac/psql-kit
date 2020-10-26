import Foundation
import SQLKit

public protocol SelectSQLExpression {
    associatedtype Select: SQLExpression
    var selectSqlExpression: Select { get }
}

public protocol FromSQLExpression {
    associatedtype From: SQLExpression
    var fromSqlExpression: From { get }
}

public protocol GroupBySQLExpression {
    associatedtype GroupBy: SQLExpression
    var groupBySqlExpression: GroupBy { get }
}

public protocol OrderBySQLExpression {
    associatedtype OrderBy: SQLExpression
    var orderBySqlExpression: OrderBy { get }
}

public protocol CompareSQLExpression {
    associatedtype Compare: SQLExpression
    var compareSqlExpression: Compare { get }
}

public protocol JoinSQLExpression {
    associatedtype Join: SQLExpression
    var joinSqlExpression: Join { get }
}

public protocol WhereSQLExpression {
    associatedtype Where: SQLExpression
    var whereSqlExpression: Where { get }
}

public protocol HavingSQLExpression {
    associatedtype Having: SQLExpression
    var havingSqlExpression: Having { get }
}

public protocol QuerySQLExpression {
    associatedtype Query: SQLExpression
    var querySqlExpression: Query { get }
}

public protocol WithSQLExpression {
    associatedtype With: SQLExpression
    var withSqlExpression: With { get }
}

public protocol UnionSQLExpression {
    associatedtype Union: SQLExpression
    var unionSqlExpression: Union { get }
}
