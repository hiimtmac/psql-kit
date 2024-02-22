// JoinBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias JoinBuilder = Builder<(any JoinSQLExpression)>

extension Builder where T == (any JoinSQLExpression) {
    public static func buildExpression<U>(
        _ expression: U
    ) -> Component where U: JoinSQLExpression {
        [expression]
    }
}
