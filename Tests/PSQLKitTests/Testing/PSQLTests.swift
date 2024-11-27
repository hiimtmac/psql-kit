// PSQLTests.swift
// Copyright (c) 2024 hiimtmac inc.

import Foundation
import PostgresKit
import SQLKit
@testable import PSQLKit

@CTE("my_model")
struct PSQLModel {
    var id: UUID?
    var name: String?
    var title: String
    var age: Int
    var money: Double
    var birthday: Date
    var category: Category
    var pet: Pet

    @CTE("pets")
    struct Pet: JSONBCol {
        var name: String
        var type: String
        var info: Info

        @CTE("infos")
        struct Info: JSONBCol {
            var name: String
        }
    }

    enum Category: String, Codable, Equatable, TypeEquatable, PSQLExpression {
        case yes
        case no

        static var postgresDataType: PostgresDataType { .text }
    }
}
