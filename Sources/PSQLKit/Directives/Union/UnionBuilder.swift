// UnionBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias UnionBuilder = Builder<(any UnionSQLExpression)>

extension Builder where T == (any UnionSQLExpression) {
    public static func buildExpression<U>(
        _ expression: U
    ) -> Component where U: UnionSQLExpression {
        [expression]
    }
}
