// SelectBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias SelectBuilder = Builder<(any SelectSQLExpression)>

extension Builder where T == (any SelectSQLExpression) {
    public static func buildExpression<U>(
        _ expression: U
    ) -> Component where U: SelectSQLExpression {
        [expression]
    }
}
