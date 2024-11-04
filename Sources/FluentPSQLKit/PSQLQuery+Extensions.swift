//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-04.
//

import FluentKit
import PostgresKit
import PSQLKit

extension PSQLQuery {
    public func execute(on database: some Database) -> PSQLQueryFetcher {
        let psqlDatabase = database as! (any PostgresDatabase)
        let sqlDatabase = psqlDatabase.sql()

        return PSQLQueryFetcher(query: self, database: sqlDatabase)
    }
}
