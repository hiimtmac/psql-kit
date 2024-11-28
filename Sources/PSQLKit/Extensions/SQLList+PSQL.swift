// SQLList+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

extension SQLList {
    init<each T>(arrowSQLExpressions expressions: repeat each T) where repeat each T: BaseSQLExpression {
        var collector = [any SQLExpression]()
        for expression in repeat each expressions {
            collector.append(expression.baseSqlExpression)
        }
        self.init(collector, separator: SQLRaw("->"))
    }
}
