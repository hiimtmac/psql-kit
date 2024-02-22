// ArrayRemoveExpression.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

public struct ArrayRemoveExpression<Content, T>: AggregateExpression where
    Content: PSQLArrayRepresentable & TypeEquatable,
    T: TypeEquatable,
    Content.CompareType == T.CompareType
{
    let content: Content
    let remove: T

    public init(_ content: Content, remove: T) {
        self.content = content
        self.remove = remove
    }
}

extension ArrayRemoveExpression: SelectSQLExpression where
    Content: SelectSQLExpression,
    T: PSQLExpression & SelectSQLExpression
{
    public var selectSqlExpression: some SQLExpression {
        _Select(content: self.content, remove: self.remove)
    }

    private struct _Select: SQLExpression {
        let content: Content
        let remove: T

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_REMOVE")
            serializer.write("(")
            self.content.selectSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.remove.selectSqlExpression.serialize(to: &serializer)
            serializer.write(")")
            fatalError()
//            PostgresDataType.array(T.postgresDataType).serialize(to: &serializer)
        }
    }
}

extension ArrayRemoveExpression: CompareSQLExpression where
    Content: CompareSQLExpression,
    T: CompareSQLExpression
{
    public var compareSqlExpression: some SQLExpression {
        _Compare(content: self.content, remove: self.remove)
    }

    private struct _Compare: SQLExpression {
        let content: Content
        let remove: T

        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("ARRAY_REMOVE")
            serializer.write("(")
            self.content.compareSqlExpression.serialize(to: &serializer)
            serializer.writeComma()
            serializer.writeSpace()
            self.remove.compareSqlExpression.serialize(to: &serializer)
            serializer.write(")")
        }
    }
}

extension ArrayRemoveExpression: TypeEquatable where Content: TypeEquatable {
    public typealias CompareType = [Content.CompareType]
}

extension ArrayRemoveExpression {
    public func `as`(_ alias: String) -> ExpressionAlias<ArrayRemoveExpression<Content, T>> {
        ExpressionAlias(expression: self, alias: alias)
    }
}
