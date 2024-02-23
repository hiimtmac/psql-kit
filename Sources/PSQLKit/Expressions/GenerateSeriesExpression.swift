// GenerateSeriesExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct GenerateSeriesExpression<Content>: SQLExpression where Content: SelectSQLExpression {
    let lower: Content
    let upper: Content
    let interval: any SQLExpression

    public init(from lower: Content, to upper: Content, interval: any SQLExpression) {
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
        PostgresDataType.interval.serialize(to: &serializer)
        serializer.write(")")
    }
}

extension GenerateSeriesExpression: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension GenerateSeriesExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<GenerateSeriesExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}

extension GenerateSeriesExpression: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression { self }
}
