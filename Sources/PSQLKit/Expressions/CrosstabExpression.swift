// CrosstabExpression.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public struct CrosstabExpression<Source, Category>: Sendable where
    Source: QuerySQLExpression & Sendable,
    Category: QuerySQLExpression & Sendable
{
    let source: Source
    let category: Category
    let record: Record

    public init(
        _ record: Record,
        @QueryBuilder source: () -> Source,
        @QueryBuilder category: () -> Category
    ) {
        self.record = record
        self.source = source()
        self.category = category()
    }
}

extension CrosstabExpression: FromSQLExpression {
    public var fromSqlExpression: some SQLExpression {
        _From(source: self.source, category: self.category, record: self.record)
    }

    struct _From: SQLExpression {
        let source: Source
        let category: Category
        let record: Record
        
        func serialize(to serializer: inout SQLSerializer) {
            serializer.write("CROSSTAB")
            serializer.write("(")
            serializer.writeLiteralQuote()
            Environment.$escapeIdentifiers.withValue(true) {
                self.source.querySqlExpression.serialize(to: &serializer)
            }
            serializer.writeLiteralQuote()
            serializer.write(",")
            serializer.writeSpace()
            serializer.writeLiteralQuote()
            Environment.$escapeIdentifiers.withValue(true) {
                self.category.querySqlExpression.serialize(to: &serializer)
            }
            serializer.writeLiteralQuote()
            serializer.write(")")
            serializer.writeSpaced("AS")
            self.record.serialize(to: &serializer)
        }
    }
}
