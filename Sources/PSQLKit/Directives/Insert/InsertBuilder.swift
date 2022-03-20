// InsertBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias InsertBuilder = Builder<InsertSQLExpression>

extension Builder where T == InsertSQLExpression {
    public static func buildExpression<T>(
        _ expression: T
    ) -> Component where T: InsertSQLExpression {
        [expression]
    }
}
