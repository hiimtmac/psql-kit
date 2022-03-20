// WithBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias WithBuilder = Builder<WithSQLExpression>

extension Builder where T == WithSQLExpression {
    public static func buildExpression<T>(
        _ expression: T
    ) -> Component where T: WithSQLExpression {
        [expression]
    }
}
