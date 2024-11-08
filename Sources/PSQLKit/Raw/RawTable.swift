// RawTable.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct RawTable: SQLExpression {
    let table: String

    public init(_ table: String) {
        self.table = table
    }

    public func serialize(to serializer: inout SQLSerializer) {
        serializer.writeQuoted(self.table)
    }
}

extension RawTable: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression { self }
}
