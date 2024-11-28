// QueryTuple.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct QueryTuple<each T>: Sendable where repeat each T: Sendable {
    let content: (repeat each T)

    init(_ content: repeat each T) {
        self.content = (repeat each content)
    }
}

extension QueryTuple: FromSQLExpression where repeat each T: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.fromIsNull else { continue }
            collector.append(expression.fromSqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(", "))
    }
}

extension QueryTuple: GroupBySQLExpression where repeat each T: GroupBySQLExpression {
    public var groupBySqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.groupByIsNull else { continue }
            collector.append(expression.groupBySqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(", "))
    }
}

extension QueryTuple: HavingSQLExpression where repeat each T: HavingSQLExpression {
    public var havingSqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.havingIsNull else { continue }
            collector.append(expression.havingSqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(" AND "))
    }
}

extension QueryTuple: InsertSQLExpression where repeat each T: InsertSQLExpression {
    public var insertColumnSqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.insertIsNull else { continue }
            collector.append(expression.insertColumnSqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(", "))
    }

    public var insertValueSqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.insertIsNull else { continue }
            collector.append(expression.insertValueSqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(", "))
    }
}

extension QueryTuple: JoinSQLExpression where repeat each T: JoinSQLExpression {
    public var joinSqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.joinIsNull else { continue }
            collector.append(expression.joinSqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(" AND "))
    }
}

extension QueryTuple: OrderBySQLExpression where repeat each T: OrderBySQLExpression {
    public var orderBySqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.orderByIsNull else { continue }
            collector.append(expression.orderBySqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(", "))
    }
}

extension QueryTuple: QuerySQLExpression where repeat each T: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.queryIsNull else { continue }
            collector.append(expression.querySqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(" "))
    }
}

extension QueryTuple: SelectSQLExpression where repeat each T: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.selectIsNull else { continue }
            collector.append(expression.selectSqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(", "))
    }
}

extension QueryTuple: UnionSQLExpression where repeat each T: UnionSQLExpression {
    public var unionSqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.unionIsNull else { continue }
            collector.append(expression.unionSqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(" UNION "))
    }
}

extension QueryTuple: UpdateSQLExpression where repeat each T: UpdateSQLExpression {
    public var updateSqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.updateIsNull else { continue }
            collector.append(expression.updateSqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(", "))
    }
}

extension QueryTuple: WhereSQLExpression where repeat each T: WhereSQLExpression {
    public var whereSqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.whereIsNull else { continue }
            collector.append(expression.whereSqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(" AND "))
    }
}

extension QueryTuple: WithSQLExpression where repeat each T: WithSQLExpression {
    public var withSqlExpression: some SQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each content {
            guard !expression.withIsNull else { continue }
            collector.append(expression.withSqlExpression)
        }
        return SQLList(collector, separator: SQLRaw(", "))
    }
}
