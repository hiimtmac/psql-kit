// PSQLQuery.swift
// Copyright (c) 2024 hiimtmac inc.

import protocol FluentKit.Database
import Foundation
import protocol PostgresNIO.PostgresDatabase
import protocol SQLKit.SQLDatabase
import protocol SQLKit.SQLExpression
import struct SQLKit.SQLSerializer

public protocol PSQLQuery: SQLExpression, QuerySQLExpression {}

extension PSQLQuery {
    public func execute(on database: some Database) -> PSQLQueryFetcher {
        let psqlDatabase = database as! (any PostgresDatabase)
        let sqlDatabase = psqlDatabase.sql()

        return PSQLQueryFetcher(query: self, database: sqlDatabase)
    }
}

extension QueryDirective: PSQLQuery {
    public var querySqlExpression: some SQLExpression { self }
}
