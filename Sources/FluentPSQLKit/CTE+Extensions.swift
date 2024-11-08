// FluentTable.swift
// Copyright (c) 2024 hiimtmac inc.

import FluentKit
import PSQLKit
import SQLKit

extension Table where Self: Model {
    public static var schemaName: String? { space }
    public static var tableName: String { schema }
}
