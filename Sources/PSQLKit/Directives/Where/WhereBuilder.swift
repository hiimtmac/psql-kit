// WhereBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias WhereBuilder = Builder<(any WhereSQLExpression)>

extension Builder where T == (any WhereSQLExpression) {
    public static func buildExpression<U>(
        _ expression: U
    ) -> Component where U: WhereSQLExpression {
        [expression]
    }
}
