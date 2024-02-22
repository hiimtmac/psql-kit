// HavingBuilder.swift
// Copyright © 2022 hiimtmac

import Foundation

typealias HavingBuilder = Builder<(any HavingSQLExpression)>

extension Builder where T == (any HavingSQLExpression) {
    public static func buildExpression<U>(
        _ expression: U
    ) -> Component where U: HavingSQLExpression {
        [expression]
    }
}
