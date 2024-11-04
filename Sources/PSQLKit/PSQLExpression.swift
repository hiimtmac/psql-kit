// PSQLExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

public protocol PSQLExpression {
    static var postgresDataType: PostgresDataType { get }
}

extension PSQLExpression where Self: SQLExpression {
    public func `as`(_ alias: String) -> RawValue<Self>.Alias {
        RawValue.Alias(value: self, alias: alias)
    }
}

extension PSQLExpression where Self: Encodable & Sendable {
    public func asBind() -> PSQLBind<Self> {
        .init(self)
    }
}

extension PSQLExpression where Self: RawRepresentable, RawValue: PSQLExpression {
    public static var postgresDataType: PostgresDataType {
        RawValue.postgresDataType
    }
}
