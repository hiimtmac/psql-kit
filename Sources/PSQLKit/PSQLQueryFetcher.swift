// PSQLQueryFetcher.swift
// Copyright © 2022 hiimtmac

import SQLKit

public final class PSQLQueryFetcher: SQLQueryFetcher {
    public var query: any SQLExpression
    public var database: any SQLDatabase

    init(query: some SQLExpression, database: some SQLDatabase) {
        self.query = query
        self.database = database
    }
}
