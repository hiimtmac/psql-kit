// OrderByBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias OrderByBuilder = Builder<(any OrderBySQLExpression)>

extension Builder where T == (any OrderBySQLExpression) {
    public static func buildExpression<U>(
        _ expression: U
    ) -> Component where U: OrderBySQLExpression {
        [expression]
    }
}
