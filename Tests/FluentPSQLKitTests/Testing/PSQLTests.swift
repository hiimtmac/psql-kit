// PSQLTests.swift
// Copyright (c) 2024 hiimtmac inc.

import FluentKit
import Foundation
import PostgresKit
import SQLKit
@testable import FluentPSQLKit

@FluentCTE("my_model")
final class FluentModel: Model, @unchecked Sendable {
    @ID
    var id: UUID?
    @OptionalField(key: "name")
    var name: String?
    @Field(key: "title")
    var title: String
    @Field(key: "age")
    var age: Int
    @Field(key: "money")
    var money: Double
    @Field(key: "birthday")
    var birthday: Date
    @Field(key: "category")
    var category: Category
    @Group(key: "pet")
    var pet: Pet

    init() {}

    @FluentCTE("pets")
    final class Pet: Model, JSONBCol, @unchecked Sendable {
        @ID
        var id: UUID?
        @Field(key: "name")
        var name: String
        @Field(key: "type")
        var type: String
        @Group(key: "info")
        var info: Info

        init() {}

        @FluentCTE("infos")
        final class Info: Model, JSONBCol, @unchecked Sendable {
            @ID
            var id: UUID?
            @Field(key: "name")
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

extension SQLSerializer {
    static var test: SQLSerializer {
        SQLSerializer(database: TestSQLDatabase())
    }
}
