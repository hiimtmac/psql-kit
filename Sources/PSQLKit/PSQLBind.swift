// PSQLBind.swift
// Copyright (c) 2024 hiimtmac inc.

import struct SQLKit.SQLBind
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct PSQLBind<T> where T: PSQLExpression & Encodable {
    let value: T

    public init(_ value: T) {
        self.value = value
    }
}

extension PSQLBind: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        SQLBind(self.value).serialize(to: &serializer)
    }
}

extension PSQLBind: CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}

extension PSQLBind: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension PSQLBind: Equatable where T: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

extension PSQLBind: Comparable where T: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}

extension PSQLBind: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}
