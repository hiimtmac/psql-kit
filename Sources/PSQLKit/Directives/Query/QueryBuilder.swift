// QueryBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias QueryBuilder = Builder<(any QuerySQLExpression)>

extension Builder where T == (any QuerySQLExpression) {
    public static func buildExpression<U>(
        _ expression: U
    ) -> Component where U: QuerySQLExpression {
        [expression]
    }
}
