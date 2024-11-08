// FluentTable.swift
// Copyright (c) 2024 hiimtmac inc.

import FluentKit
import PSQLKit
import SQLKit

extension CTE where Self: Model {
    public static var space: String? { schemaName }
    public static var schema: String { tableName }
}
