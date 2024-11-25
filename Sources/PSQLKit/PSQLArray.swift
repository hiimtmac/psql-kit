// PSQLArray.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

public protocol PSQLArrayRepresentable {}

public struct PSQLArray<T>: PSQLArrayRepresentable, Sendable where
    T: PSQLExpression & Sendable
{
    let items: [T]

    public init(_ items: [T]) {
        self.items = items
    }
}

extension PSQLArray: TypeEquatable where T: TypeEquatable {
    public typealias CompareType = T.CompareType
}

extension PSQLArray: SelectSQLExpression where
    T: SQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(items: self.items, arrayType: [T].postgresDataType)
    }

    struct _Select: SQLExpression {
        let items: [T]
        let arrayType: PostgresDataType

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY")
            serializer.write("[")
            SQLList(self.items).serialize(to: &serializer)
            serializer.write("]")
            serializer.writeCast(arrayType)
        }
    }
}

extension PSQLArray: CompareSQLExpression where
    T: SQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(items: self.items)
    }

    struct _Compare: SQLExpression {
        let items: [T]

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY")
            serializer.write("[")
            SQLList(self.items).serialize(to: &serializer)
            serializer.write("]")
        }
    }
}
