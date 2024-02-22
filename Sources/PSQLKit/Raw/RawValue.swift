// RawValue.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct RawValue<T> where T: PSQLExpression & SQLExpression {
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

extension RawValue: SelectSQLExpression {
    struct _Select: SQLExpression {
        let value: T

        func serialize(to serializer: inout SQLSerializer) {
            self.value.serialize(to: &serializer)
            T.postgresDataType.serialize(to: &serializer)
        }
    }

    public var selectSqlExpression: some SQLExpression {
        _Select(value: self.value)
    }
}

// MARK: - Alias

extension RawValue {
    public struct Alias {
        let value: T
        let alias: String

        public init(value: T, alias: String) {
            self.value = value
            self.alias = alias
        }
    }
}

extension RawValue.Alias: SelectSQLExpression {
    private struct _Select: SQLExpression {
        let value: T
        let alias: String

        func serialize(to serializer: inout SQLSerializer) {
            self.value.serialize(to: &serializer)
            T.postgresDataType.serialize(to: &serializer)

            serializer.writeSpace()
            serializer.write("AS")
            serializer.writeSpace()

            serializer.writeQuote()
            serializer.write(self.alias)
            serializer.writeQuote()
        }
    }

    public var selectSqlExpression: some SQLExpression {
        _Select(value: self.value, alias: alias)
    }
}

extension RawValue.Alias: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}
