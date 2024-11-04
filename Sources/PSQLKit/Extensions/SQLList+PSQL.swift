// SQLList+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import protocol SQLKit.SQLExpression
import struct SQLKit.SQLList
import struct SQLKit.SQLRaw

extension SQLList {
    init<each T>(concatSQLExpressions expressions: repeat each T) where repeat each T: BaseSQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(concat: each expressions))
        self.init(collector.expressions, separator: SQLRaw(", "))
    }
}

extension SQLList {
    init<each T>(fromSQLExpressions expressions: repeat each T) where repeat each T: FromSQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(exp: each expressions))
        self.init(collector.expressions, separator: SQLRaw(", "))
    }
}

extension SQLList {
    init<each T>(groupBySQLExpressions expressions: repeat each T) where repeat each T: GroupBySQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(exp: each expressions))
        self.init(collector.expressions, separator: SQLRaw(", "))
    }
}

extension SQLList {
    init<each T>(havingSQLExpressions expressions: repeat each T) where repeat each T: HavingSQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(exp: each expressions))
        self.init(collector.expressions, separator: SQLRaw(" AND "))
    }
}

extension SQLList {
    init<each T>(insertColumnSQLExpressions expressions: repeat each T) where repeat each T: InsertSQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(column: each expressions))
        self.init(collector.expressions, separator: SQLRaw(", "))
    }
    
    init<each T>(insertValueSQLExpressions expressions: repeat each T) where repeat each T: InsertSQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(value: each expressions))
        self.init(collector.expressions, separator: SQLRaw(", "))
    }

}

extension SQLList {
    init<each T>(joinSQLExpressions expressions: repeat each T) where repeat each T: JoinSQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(exp: each expressions))
        self.init(collector.expressions, separator: SQLRaw(" AND "))
    }
}

extension SQLList {
    init<each T>(orderBySQLExpressions expressions: repeat each T) where repeat each T: OrderBySQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(exp: each expressions))
        self.init(collector.expressions, separator: SQLRaw(", "))
    }
}

extension SQLList {
    init<each T>(querySQLExpressions expressions: repeat each T) where repeat each T: QuerySQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(exp: each expressions))
        self.init(collector.expressions, separator: SQLRaw(" "))
    }
}

extension SQLList {
    init<each T>(selectSQLExpressions expressions: repeat each T) where repeat each T: SelectSQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(exp: each expressions))
        self.init(collector.expressions, separator: SQLRaw(", "))
    }
}

extension SQLList {
    init<each T>(unionSQLExpressions expressions: repeat each T) where repeat each T: UnionSQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(exp: each expressions))
        self.init(collector.expressions, separator: SQLRaw(" UNION "))
    }
}

extension SQLList {
    init<each T>(updateSQLExpressions expressions: repeat each T) where repeat each T: UpdateSQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(exp: each expressions))
        self.init(collector.expressions, separator: SQLRaw(", "))
    }
}

extension SQLList {
    init<each T>(whereSQLExpressions expressions: repeat each T) where repeat each T: WhereSQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(exp: each expressions))
        self.init(collector.expressions, separator: SQLRaw(" AND "))
    }
}

extension SQLList {
    init<each T>(withSQLExpressions expressions: repeat each T) where repeat each T: WithSQLExpression {
        var collector = Collector()
        _ = (repeat collector.append(exp: each expressions))
        self.init(collector.expressions, separator: SQLRaw(", "))
    }
}
