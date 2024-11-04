// PSQLQueryFetcher.swift
// Copyright (c) 2024 hiimtmac inc.

import SQLKit

public final class PSQLQueryFetcher: SQLQueryFetcher {
    public var query: any SQLExpression
    public var database: any SQLDatabase

    public init(query: some SQLExpression, database: some SQLDatabase) {
        self.query = query
        self.database = database
    }
}
