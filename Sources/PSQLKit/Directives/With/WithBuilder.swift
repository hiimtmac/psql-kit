// WithBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias WithBuilder = Builder<(any WithSQLExpression)>

extension Builder where T == (any WithSQLExpression) {
    public static func buildExpression<U>(
        _ expression: U
    ) -> Component where U: WithSQLExpression {
        [expression]
    }
}
