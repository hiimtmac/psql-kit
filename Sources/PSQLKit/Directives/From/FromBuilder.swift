// FromBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias FromBuilder = Builder<(any FromSQLExpression)>

extension Builder where T == (any FromSQLExpression) {
    public static func buildExpression<U>(
        _ expression: U
    ) -> Component where U: FromSQLExpression {
        [expression]
    }
}
