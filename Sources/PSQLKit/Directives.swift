// Directives.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import protocol SQLKit.SQLExpression

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
    var fromIsNull: Bool { get }
}

extension FromSQLExpression {
    public var fromIsNull: Bool { false }
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
    var joinIsNull: Bool { get }
}

extension JoinSQLExpression {
    public var joinIsNull: Bool { false }
}

public protocol WhereSQLExpression {
    associatedtype WhereExpression: SQLExpression
    var whereSqlExpression: WhereExpression { get }
    var whereIsNull: Bool { get }
}

extension WhereSQLExpression {
    public var whereIsNull: Bool { false }
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
    var queryIsNull: Bool { get }
}

extension QuerySQLExpression {
    public var queryIsNull: Bool { false }
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
    var insertIsNull: Bool { get }
}

extension InsertSQLExpression {
    public var insertIsNull: Bool { false }
}

public protocol UpdateSQLExpression {
    associatedtype UpdateExpression: SQLExpression
    var updateSqlExpression: UpdateExpression { get }
    var updateIsNull: Bool { get }
}

extension UpdateSQLExpression {
    public var updateIsNull: Bool { false }
}
