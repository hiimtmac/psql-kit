// PSQLQuery.swift
// Copyright © 2022 hiimtmac

import Foundation
import PostgresKit
import SQLKit

public protocol PSQLQuery: SQLExpression, QuerySQLExpression {}

extension PSQLQuery {
    public func raw(database: any SQLDatabase = Self.testDB) -> (sql: String, binds: [any Encodable]) {
        var serializer = SQLSerializer(database: database)
        self.serialize(to: &serializer)
        return (serializer.sql, serializer.binds)
    }

    public static var testDB: any SQLDatabase { TestSQLDatabase() }

    public func execute(on database: some Database) -> PSQLQueryFetcher {
        let psqlDatabase = database as! (any PostgresDatabase)
        let sqlDatabase = psqlDatabase.sql()

        return PSQLQueryFetcher(query: self, database: sqlDatabase)
    }
}

extension QueryDirective: PSQLQuery {
    public var querySqlExpression: some SQLExpression { self }
}
