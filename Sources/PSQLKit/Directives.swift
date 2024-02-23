// Directives.swift
// Copyright © 2022 hiimtmac

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
    associatedtype BaseExpression: SQLExpression
    var baseSqlExpression: BaseExpression { get }
}

public protocol SelectSQLExpression {
    associatedtype SelectExpression: SQLExpression
    var selectSqlExpression: SelectExpression { get }
    var selectIsNull: Bool { get }
}

extension SelectSQLExpression {
    public var selectIsNull: Bool { false }
}

public protocol FromSQLExpression {
    associatedtype FromExpression: SQLExpression
    var fromSqlExpression: FromExpression { get }
}

public protocol GroupBySQLExpression {
    associatedtype GroupByExpression: SQLExpression
    var groupBySqlExpression: GroupByExpression { get }
    var groupByIsNull: Bool { get }
}

extension GroupBySQLExpression {
    public var groupByIsNull: Bool { false }
}

public protocol OrderBySQLExpression {
    associatedtype OrderByExpression: SQLExpression
    var orderBySqlExpression: OrderByExpression { get }
    var orderByIsNull: Bool { get }
}

extension OrderBySQLExpression {
    public var orderByIsNull: Bool { false }
}

public protocol CompareSQLExpression {
    associatedtype CompareExpression: SQLExpression
    var compareSqlExpression: CompareExpression { get }
}

public protocol JoinSQLExpression {
    associatedtype JoinExpression: SQLExpression
    var joinSqlExpression: JoinExpression { get }
}

public protocol WhereSQLExpression {
    associatedtype WhereExpression: SQLExpression
    var whereSqlExpression: WhereExpression { get }
}

public protocol HavingSQLExpression {
    associatedtype HavingExpression: SQLExpression
    var havingSqlExpression: HavingExpression { get }
    var havingIsNull: Bool { get }
}

extension HavingSQLExpression {
    public var havingIsNull: Bool { false }
}

public protocol QuerySQLExpression {
    associatedtype QueryExpression: SQLExpression
    var querySqlExpression: QueryExpression { get }
}

public protocol WithSQLExpression {
    associatedtype WithExpression: SQLExpression
    var withSqlExpression: WithExpression { get }
    var withIsNull: Bool { get }
}

extension WithSQLExpression {
    public var withIsNull: Bool { false }
}

public protocol UnionSQLExpression {
    associatedtype UnionExpression: SQLExpression
    var unionSqlExpression: UnionExpression { get }
    var unionIsNull: Bool { get }
}

extension UnionSQLExpression {
    public var unionIsNull: Bool { false }
}

public protocol MutationSQLExpression {
    associatedtype MutationExpression: SQLExpression
    var mutationSqlExpression: MutationExpression { get }
}

public protocol InsertSQLExpression {
    associatedtype InsertColumnExpression: SQLExpression
    associatedtype InsertValueExpression: SQLExpression
    var insertColumnSqlExpression: InsertColumnExpression { get }
    var insertValueSqlExpression: InsertValueExpression { get }
}

public protocol UpdateSQLExpression {
    associatedtype UpdateExpression: SQLExpression
    var updateSqlExpression: UpdateExpression { get }
}
