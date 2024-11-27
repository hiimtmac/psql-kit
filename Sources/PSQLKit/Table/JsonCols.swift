// TableObject.swift
// Copyright (c) 2024 hiimtmac inc.

import struct PostgresNIO.PostgresDataType

public protocol _JSONCol: PSQLExpression, Decodable {}

public protocol JSONCol: _JSONCol {}

extension JSONCol {
    public static var postgresDataType: PostgresDataType { .json }
}

public protocol JSONBCol: _JSONCol {}

extension JSONBCol {
    public static var postgresDataType: PostgresDataType { .jsonb }
}
