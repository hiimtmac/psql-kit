import Foundation
import SQLKit

public typealias FROM = FromDirective
public typealias GROUPBY = GroupByDirective
public typealias HAVING = HavingDirective
public typealias JOIN = JoinDirective
public typealias ORDERBY = OrderByDirective
public typealias QUERY = QueryDirective
public typealias SELECT = SelectDirective
public typealias WHERE = WhereDirective
public typealias WITH = WithDirective
public typealias UNION = UnionDirective
public typealias RETURNING = ReturningDirective
public typealias INSERT = InsertDirective
public typealias UPDATE = UpdateDirective
public typealias DELETE = DeleteDirective

public protocol BaseSQLExpression {
    var baseSqlExpression: SQLExpression { get }
}

public protocol SelectSQLExpression {
    var selectSqlExpression: SQLExpression { get }
}

public protocol FromSQLExpression {
    var fromSqlExpression: SQLExpression { get }
}

public protocol GroupBySQLExpression {
    var groupBySqlExpression: SQLExpression { get }
}

public protocol OrderBySQLExpression {
    var orderBySqlExpression: SQLExpression { get }
}

public protocol CompareSQLExpression {
    var compareSqlExpression: SQLExpression { get }
}

public protocol JoinSQLExpression {
    var joinSqlExpression: SQLExpression { get }
}

public protocol WhereSQLExpression {
    var whereSqlExpression: SQLExpression { get }
}

public protocol HavingSQLExpression {
    var havingSqlExpression: SQLExpression { get }
}

public protocol QuerySQLExpression {
    var querySqlExpression: SQLExpression { get }
}

public protocol WithSQLExpression {
    var withSqlExpression: SQLExpression { get }
}

public protocol UnionSQLExpression {
    var unionSqlExpression: SQLExpression { get }
}

public protocol MutationSQLExpression {
    var mutationSqlExpression: SQLExpression { get }
}

public protocol InsertSQLExpression {
    var insertColumnSqlExpression: SQLExpression { get }
    var insertValueSqlExpression: SQLExpression { get }
}

public protocol UpdateSQLExpression {
    var updateSqlExpression: SQLExpression { get }
}
