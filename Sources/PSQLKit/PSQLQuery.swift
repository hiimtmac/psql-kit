// PSQLQuery.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresNIO
import SQLKit

public protocol PSQLQuery: SQLExpression, QuerySQLExpression {}

extension QueryDirective: PSQLQuery {
    public var querySqlExpression: some SQLExpression { self }
}
