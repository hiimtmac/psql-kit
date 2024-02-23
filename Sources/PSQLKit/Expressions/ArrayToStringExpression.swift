// ArrayToStringExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import struct PostgresNIO.PostgresDataType
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public struct ArrayToStringExpression<Content>: AggregateExpression where
    Content: PSQLArrayRepresentable
{
    let content: Content
    let delimiter: String
    let ifNull: String?

    public init(_ content: Content, delimiter: String, ifNull: String? = nil) {
        self.content = content
        self.delimiter = delimiter
        self.ifNull = ifNull
    }
}

extension ArrayToStringExpression: SelectSQLExpression where
    Content: SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content, delimiter: self.delimiter, ifNull: self.ifNull)
    }

    private struct _Select: SQLExpression {
        let content: Content
        let delimiter: String
        let ifNull: String?

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_TO_STRING")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.delimiter.serialize(to: &serializer)
            if let ifNull = ifNull {
                serializer.writeComma()
                serializer.writeSpace()
                ifNull.serialize(to: &serializer)
            }
            serializer.write(")")
            PostgresDataType.text.serialize(to: &serializer)
        }
    }
}

extension ArrayToStringExpression: CompareSQLExpression where
    Content: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content, delimiter: self.delimiter, ifNull: self.ifNull)
    }

    private struct _Compare: SQLExpression {
        let content: Content
        let delimiter: String
        let ifNull: String?

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_TO_STRING")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.delimiter.serialize(to: &serializer)
            if let ifNull = ifNull {
                serializer.writeComma()
                serializer.writeSpace()
                ifNull.serialize(to: &serializer)
            }
            serializer.write(")")
        }
    }
}

extension ArrayToStringExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = String
}

extension ArrayToStringExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayToStringExpression<Content>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
