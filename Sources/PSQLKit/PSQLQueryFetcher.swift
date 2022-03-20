// PSQLQueryFetcher.swift
// Copyright © 2022 hiimtmac

import SQLKit

public final class PSQLQueryFetcher: SQLQueryFetcher {
    public var query: SQLExpression
    public var database: SQLDatabase

    init(query: SQLExpression, database: SQLDatabase) {
        self.query = query
        self.database = database
    }
}
