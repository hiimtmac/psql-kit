// TestSQLDatabase.swift
// Copyright © 2022 hiimtmac

import Logging
import NIOCore
import NIOEmbedded
import struct PostgresKit.PostgresDialect
import protocol SQLKit.SQLDialect
import protocol SQLKit.SQLExpression
import protocol SQLKit.SQLDatabase
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
