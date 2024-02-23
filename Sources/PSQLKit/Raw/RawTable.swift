// RawTable.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct RawTable: SQLExpression {
    let table: String

    public init(_ table: String) {
        self.table = table
    }

    public func serialize(to serializer: inout SQLSerializer) {
        serializer.writeQuote()
        serializer.write(self.table)
        serializer.writeQuote()
    }
}

extension RawTable: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression { self }
}
