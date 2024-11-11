// PSQLQuery+Extensions.swift
// Copyright (c) 2024 hiimtmac inc.

import FluentKit
import PostgresKit
import PSQLKit

extension PSQLQuery {
    public func execute(on database: any Database) -> PSQLQueryFetcher {
        let psqlDatabase = database as! (any PostgresDatabase)
        let sqlDatabase = psqlDatabase.sql()

        return PSQLQueryFetcher(query: self, database: sqlDatabase)
    }
}
