// SelectBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias SelectBuilder = Builder<SelectSQLExpression>

extension Builder where T == SelectSQLExpression {
    public static func buildExpression<T>(
        _ expression: T
    ) -> Component where T: SelectSQLExpression {
        [expression]
    }
}
