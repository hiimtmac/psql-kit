// SQLList+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

extension SQLList {
    init<each T>(concatSQLExpressions expressions: repeat each T) where repeat each T: BaseSQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            collector.append(expression.baseSqlExpression)
        }
        self.init(collector, separator: SQLRaw(", "))
    }
}

extension SQLList {
    init<each T>(fromSQLExpressions expressions: repeat each T) where repeat each T: FromSQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.fromIsNull else { continue }
            collector.append(expression.fromSqlExpression)
        }
        self.init(collector, separator: SQLRaw(", "))
    }
}

extension SQLList {
    init<each T>(groupBySQLExpressions expressions: repeat each T) where repeat each T: GroupBySQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.groupByIsNull else { continue }
            collector.append(expression.groupBySqlExpression)
        }
        self.init(collector, separator: SQLRaw(", "))
    }
}

extension SQLList {
    init<each T>(havingSQLExpressions expressions: repeat each T) where repeat each T: HavingSQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.havingIsNull else { continue }
            collector.append(expression.havingSqlExpression)
        }
        self.init(collector, separator: SQLRaw(" AND "))
    }
}

extension SQLList {
    init<each T>(insertColumnSQLExpressions expressions: repeat each T) where repeat each T: InsertSQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.insertIsNull else { continue }
            collector.append(expression.insertColumnSqlExpression)
        }
        self.init(collector, separator: SQLRaw(", "))
    }
    
    init<each T>(insertValueSQLExpressions expressions: repeat each T) where repeat each T: InsertSQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.insertIsNull else { continue }
            collector.append(expression.insertValueSqlExpression)
        }
        self.init(collector, separator: SQLRaw(", "))
    }

}

extension SQLList {
    init<each T>(joinSQLExpressions expressions: repeat each T) where repeat each T: JoinSQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.joinIsNull else { continue }
            collector.append(expression.joinSqlExpression)
        }
        self.init(collector, separator: SQLRaw(" AND "))
    }
}

extension SQLList {
    init<each T>(orderBySQLExpressions expressions: repeat each T) where repeat each T: OrderBySQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.orderByIsNull else { continue }
            collector.append(expression.orderBySqlExpression)
        }
        self.init(collector, separator: SQLRaw(", "))
    }
}

extension SQLList {
    init<each T>(querySQLExpressions expressions: repeat each T) where repeat each T: QuerySQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.queryIsNull else { continue }
            collector.append(expression.querySqlExpression)
        }
        self.init(collector, separator: SQLRaw(" "))
    }
}

extension SQLList {
    init<each T>(selectSQLExpressions expressions: repeat each T) where repeat each T: SelectSQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.selectIsNull else { continue }
            collector.append(expression.selectSqlExpression)
        }
        self.init(collector, separator: SQLRaw(", "))
    }
}

extension SQLList {
    init<each T>(unionSQLExpressions expressions: repeat each T) where repeat each T: UnionSQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.unionIsNull else { continue }
            collector.append(expression.unionSqlExpression)
        }
        self.init(collector, separator: SQLRaw(" UNION "))
    }
}

extension SQLList {
    init<each T>(updateSQLExpressions expressions: repeat each T) where repeat each T: UpdateSQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.updateIsNull else { continue }
            collector.append(expression.updateSqlExpression)
        }
        self.init(collector, separator: SQLRaw(", "))
    }
}

extension SQLList {
    init<each T>(whereSQLExpressions expressions: repeat each T) where repeat each T: WhereSQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.whereIsNull else { continue }
            collector.append(expression.whereSqlExpression)
        }
        self.init(collector, separator: SQLRaw(" AND "))
    }
}

extension SQLList {
    init<each T>(withSQLExpressions expressions: repeat each T) where repeat each T: WithSQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            guard !expression.withIsNull else { continue }
            collector.append(expression.withSqlExpression)
        }
        self.init(collector, separator: SQLRaw(", "))
    }
}
