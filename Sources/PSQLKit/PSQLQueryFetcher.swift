// PSQLQueryFetcher.swift
// Copyright (c) 2024 hiimtmac inc.

import protocol SQLKit.SQLDatabase
import protocol SQLKit.SQLExpression
import protocol SQLKit.SQLQueryFetcher

public final class PSQLQueryFetcher: SQLQueryFetcher {
    public var query: any SQLExpression
    public var database: any SQLDatabase

    init(query: some SQLExpression, database: some SQLDatabase) {
        self.query = query
        self.database = database
    }
}
