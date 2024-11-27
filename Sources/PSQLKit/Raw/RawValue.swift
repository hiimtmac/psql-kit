// RawValue.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import SQLKit

public struct RawValue<T>: Sendable where T: PSQLExpression & SQLExpression {
    let value: T

    public init(_ value: T) {
        self.value = value
    }
}

extension RawValue {
    public func `as`(_ alias: String) -> RawValue<T>.Alias {
        Alias(value: self.value, alias: alias)
    }
}

extension RawValue: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension RawValue: BaseSQLExpression {
    public var baseSqlExpression: some SQLExpression {
        self.value
    }
}

extension RawValue: SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression {
        _Select(value: self.value)
    }
    
    struct _Select: SQLExpression {
        let value: T

        func serialize(to serializer: inout SQLSerializer) {
            self.value.serialize(to: &serializer)
            serializer.writeCast(T.postgresDataType)
        }
    }
}

// MARK: - Alias

extension RawValue {
    public struct Alias: Sendable {
        let value: T
        let alias: String

        public init(value: T, alias: String) {
            self.value = value
            self.alias = alias
        }
    }
}

extension RawValue.Alias: SelectSQLExpression {
    struct _Select: SQLExpression {
        let value: T
        let alias: String

        func serialize(to serializer: inout SQLSerializer) {
            self.value.serialize(to: &serializer)
            serializer.writeCast(T.postgresDataType)

            serializer.writeSpaced("AS")

            serializer.writeIdentifier(self.alias)
        }
    }

    public var selectSqlExpression: some SQLExpression {
        _Select(value: self.value, alias: alias)
    }
}

extension RawValue.Alias: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension UUID {
    public var raw: RawValue<Self> {
        RawValue(self)
    }
}

extension String {
    public var raw: RawValue<Self> {
        RawValue(self)
    }
}

extension Int {
    public var raw: RawValue<Self> {
        RawValue(self)
    }
}

extension Double {
    public var raw: RawValue<Self> {
        RawValue(self)
    }
}

extension Float {
    public var raw: RawValue<Self> {
        RawValue(self)
    }
}

extension Bool {
    public var raw: RawValue<Self> {
        RawValue(self)
    }
}
