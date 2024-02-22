// PSQLBind.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

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
