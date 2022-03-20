// UpdateBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias UpdateBuilder = Builder<UpdateSQLExpression>

extension Builder where T == UpdateSQLExpression {
    public static func buildExpression<T>(
        _ expression: T
    ) -> Component where T: UpdateSQLExpression {
        [expression]
    }
}
