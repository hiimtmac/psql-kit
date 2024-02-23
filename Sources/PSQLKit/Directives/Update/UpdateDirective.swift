// UpdateDirective.swift
// Copyright © 2022 hiimtmac

import Foundation
import SQLKit

public struct UpdateDirective<Table: FromSQLExpression, T: UpdateSQLExpression>: SQLExpression {
    let table: Table
    let content: T
    
    init(_ table: Table, content: T) {
        self.table = table
        self.content = content
    }

    public init(_ table: Table, @UpdateBuilder content: () -> T) {
        self.table = table
        self.content = content()
    }

    public func serialize(to serializer: inout SQLSerializer) {
        guard !content.updateIsNull else { return }
        serializer.write("UPDATE")
        serializer.writeSpace()
        self.table.fromSqlExpression.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write("SET")
        serializer.writeSpace()
        content.updateSqlExpression.serialize(to: &serializer)
    }
}

extension UpdateDirective: QuerySQLExpression {
    public var querySqlExpression: some SQLExpression { self }
}
