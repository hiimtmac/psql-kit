// SelectDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct SelectDirective: SQLExpression {
    let content: [SelectSQLExpression]

    public init(@SelectBuilder builder: () -> [SelectSQLExpression]) {
        self.content = builder()
    }

    init(content: [SelectSQLExpression]) {
        self.content = content
    }

    public func serialize(to serializer: inout SQLSerializer) {
        if !self.content.isEmpty {
            serializer.write("SELECT")
            serializer.writeSpace()
            SQLList(self.content.map(\.selectSqlExpression))
                .serialize(to: &serializer)
        }
    }
}

public struct DistinctSelection: SQLExpression {
    let content: [SelectSQLExpression]

    public func serialize(to serializer: inout SQLSerializer) {
        if !self.content.isEmpty {
            serializer.write("SELECT DISTINCT")
            serializer.writeSpace()
            SQLList(self.content.map(\.selectSqlExpression))
                .serialize(to: &serializer)
        }
    }
}

extension SelectDirective {
    /// ```
    /// SELECT DISTINCT first_name, last_name
    /// FROM people
    /// ```
    ///
    public func distinct() -> DistinctSelection {
        DistinctSelection(content: self.content)
    }
}

public struct DistinctOnSelection: SQLExpression {
    let distinctOn: [SelectSQLExpression]
    let content: [SelectSQLExpression]

    public func serialize(to serializer: inout SQLSerializer) {
        if !self.content.isEmpty {
            serializer.write("SELECT DISTINCT ON")
            serializer.writeSpace()
            serializer.write("(")
            SQLList(self.distinctOn.map(\.selectSqlExpression))
                .serialize(to: &serializer)
            serializer.write(")")
            serializer.writeSpace()
            SQLList(self.content.map(\.selectSqlExpression))
                .serialize(to: &serializer)
        }
    }
}

extension SelectDirective {
    /// ```
    /// SELECT DISTINCT ON (address_id) *
    /// FROM purchases
    /// WHERE product_id = 1
    /// ORDER BY address_id, purchased_at DESC
    /// ```
    ///
    public func distinctOn(@SelectBuilder builder: () -> [SelectSQLExpression]) -> DistinctOnSelection {
        DistinctOnSelection(distinctOn: builder(), content: self.content)
    }
}

extension SelectDirective: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}

extension DistinctSelection: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}

extension DistinctOnSelection: QuerySQLExpression {
    public var querySqlExpression: SQLExpression { self }
}
