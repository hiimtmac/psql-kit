// PSQLExpression.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit

public protocol PSQLExpression {
    static var postgresColumnType: PostgresColumnType { get }
}

extension PSQLExpression where Self: SQLExpression {
    public func `as`(_ alias: String) -> RawValue<Self>.Alias {
        RawValue.Alias(value: self, alias: alias)
    }
}

extension PSQLExpression where Self: Encodable {
    public func asBind() -> PSQLBind<Self> {
        .init(self)
    }
}

extension PSQLExpression where Self: RawRepresentable, RawValue: PSQLExpression {
    public static var postgresColumnType: PostgresColumnType {
        RawValue.postgresColumnType
    }
}
