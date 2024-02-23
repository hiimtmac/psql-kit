// PSQLArray.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer
import struct SQLKit.SQLList
import struct PostgresNIO.PostgresDataType

public protocol PSQLArrayRepresentable {}

public struct PSQLArray<T>: PSQLArrayRepresentable where
    T: PSQLExpression
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

    private struct _Select: SQLExpression {
        let items: [T]
        let arrayType: PostgresDataType

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY")
            serializer.write("[")
            SQLList(self.items).serialize(to: &serializer)
            serializer.write("]")
            self.arrayType.serialize(to: &serializer)
        }
    }
}

extension PSQLArray: CompareSQLExpression where
    T: SQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(items: self.items)
    }

    private struct _Compare: SQLExpression {
        let items: [T]

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY")
            serializer.write("[")
            SQLList(self.items).serialize(to: &serializer)
            serializer.write("]")
        }
    }
}
