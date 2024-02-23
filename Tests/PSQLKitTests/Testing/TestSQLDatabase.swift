// TestSQLDatabase.swift
// Copyright (c) 2024 hiimtmac inc.

import Logging
import NIOCore
import NIOEmbedded
import struct PostgresKit.PostgresDialect
import PSQLKit
import protocol SQLKit.SQLDatabase
import protocol SQLKit.SQLDialect
import protocol SQLKit.SQLExpression
import protocol SQLKit.SQLRow
import struct SQLKit.SQLSerializer

final class TestSQLDatabase: SQLDatabase {
    let logger: Logger
    let eventLoop: any EventLoop
    var results: [String]
    let dialect: any SQLDialect = PostgresDialect()

    init() {
        self.logger = .init(label: "com.hiimtmac.psqlkit")
        self.eventLoop = EmbeddedEventLoop()
        self.results = []
    }

    func execute(sql query: any SQLExpression, _: @escaping (any SQLRow) -> Void) -> EventLoopFuture<Void> {
        var serializer = SQLSerializer(database: self)
        query.serialize(to: &serializer)
        self.results.append(serializer.sql)
        return self.eventLoop.makeSucceededFuture(())
    }
}

extension PSQLQuery {
    func raw(database: any SQLDatabase = Self.testDB) -> (sql: String, binds: [any Encodable]) {
        var serializer = SQLSerializer(database: database)
        self.serialize(to: &serializer)
        return (serializer.sql, serializer.binds)
    }

    static var testDB: any SQLDatabase { TestSQLDatabase() }
}
