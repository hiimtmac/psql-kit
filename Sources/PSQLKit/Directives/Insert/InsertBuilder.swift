// InsertBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias InsertBuilder = Builder<(any InsertSQLExpression)>

extension Builder where T == (any InsertSQLExpression) {
    public static func buildExpression<U>(
        _ expression: U
    ) -> Component where U: InsertSQLExpression {
        [expression]
    }
}
