// GenerateSeriesExpression.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

public struct GenerateSeriesExpression<Content>: SQLExpression where Content: SelectSQLExpression {
    let lower: Content
    let upper: Content
    let interval: SQLExpression

    public init(from lower: Content, to upper: Content, interval: SQLExpression) {
        self.lower = lower
        self.upper = upper
        self.interval = interval
    }

    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("GENERATE_SERIES")
        serializer.write("(")
        self.lower.selectSqlExpression.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        self.upper.selectSqlExpression.serialize(to: &serializer)
        serializer.write(",")
        serializer.writeSpace()
        self.interval.serialize(to: &serializer)
        serializer.write("::INTERVAL")
        serializer.write(")")
    }
}

extension GenerateSeriesExpression: SelectSQLExpression {
    public var selectSqlExpression: SQLExpression { self }
}

extension GenerateSeriesExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<GenerateSeriesExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension GenerateSeriesExpression: FromSQLExpression {
    public var fromSqlExpression: SQLExpression { self }
}
