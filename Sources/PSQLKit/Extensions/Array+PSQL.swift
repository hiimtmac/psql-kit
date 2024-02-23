// Array+PSQL.swift
// Copyright © 2022 hiimtmac

import Foundation
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer
import struct SQLKit.SQLList
import struct PostgresNIO.PostgresDataType

extension Array: SQLExpression where Element: SQLExpression {
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
