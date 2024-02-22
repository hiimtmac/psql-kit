// GroupByBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias GroupByBuilder = Builder<(any GroupBySQLExpression)>

extension Builder where T == (any GroupBySQLExpression) {
    public static func buildExpression<U>(
        _ expression: U
    ) -> Component where U: GroupBySQLExpression {
        [expression]
    }
}
