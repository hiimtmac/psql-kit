// Array+PSQL.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

// TODO: support sequence/collection so Set can go here?

extension Array: @retroactive SQLExpression where Element: SQLExpression {
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write("(")
        SQLList(self).serialize(to: &serializer)
        serializer.write(")")
    }
}

extension Array: TypeEquatable where Element: TypeEquatable {
    public typealias CompareType = Self
}

extension Array: PSQLExpression where Element: PSQLExpression {
    public static var postgresDataType: PostgresDataType {
        .array(Element.postgresDataType)
    }
}

extension Array: SelectSQLExpression where Element: SQLExpression & SelectSQLExpression {
    public var selectSqlExpression: some SQLExpression { self }
}

extension Array: CompareSQLExpression where Element: SQLExpression & CompareSQLExpression {
    public var compareSqlExpression: some SQLExpression { self }
}
