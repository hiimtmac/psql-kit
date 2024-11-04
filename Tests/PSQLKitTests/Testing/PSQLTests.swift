// PSQLTests.swift
// Copyright (c) 2024 hiimtmac inc.

import PostgresKit
import SQLKit
import XCTest
@testable import PSQLKit

struct PSQLModel: Table, @unchecked Sendable {
    static let schema = "my_model"

    @Column(key: "id")
    var id: UUID?
    @OptionalColumn(key: "name")
    var name: String?
    @Column(key: "title")
    var title: String
    @Column(key: "age")
    var age: Int
    @Column(key: "money")
    var money: Double
    @Column(key: "birthday")
    var birthday: Date
    @Column(key: "category")
    var category: Category
    @NestedColumn(key: "pet")
    var pet: Pet

    init() {}

    struct Pet: TableObject, Codable {
        @Column(key: "name")
        var name: String
        @Column(key: "type")
        var type: String
        @NestedColumn(key: "info")
        var info: Info

        init() {}

        struct Info: TableObject, Codable {
            @Column(key: "name")
            var name: String

            init() {}
        }
    }

    enum Category: String, Codable, Equatable, TypeEquatable, PSQLExpression {
        case yes
        case no

        static var postgresDataType: PostgresDataType { .text }
    }
}

class PSQLTestCase: XCTestCase {
    var serializer = SQLSerializer(database: TestSQLDatabase())
}
