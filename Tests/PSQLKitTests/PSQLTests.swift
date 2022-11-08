// PSQLTests.swift
// Copyright © 2022 hiimtmac

import FluentKit
import PostgresKit
import SQLKit
import XCTest
@testable import PSQLKit

final class FluentModel: Model, Table {
    static let schema = "my_model"

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

    final class Pet: Fields, TableObject {
        @Field(key: "name")
        var name: String
        @Field(key: "type")
        var type: String
        @Group(key: "info")
        var info: Info

        init() {}

        final class Info: Fields, TableObject {
            @Field(key: "name")
            var name: String

            init() {}
        }
    }
    
    enum Category: String, Codable, Equatable, TypeEquatable, PSQLExpression {
        case yes
        case no
    }
}

struct PSQLModel: Table {
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
    }
}

class PSQLTestCase: XCTestCase {
    var fluentSerializer = SQLSerializer(database: TestSQLDatabase())
    var psqlkitSerializer = SQLSerializer(database: TestSQLDatabase())
}
