// UpdateBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias UpdateBuilder = Builder<(any UpdateSQLExpression)>

extension Builder where T == (any UpdateSQLExpression) {
    public static func buildExpression<U>(
        _ expression: U
    ) -> Component where U: UpdateSQLExpression {
        [expression]
    }
}
