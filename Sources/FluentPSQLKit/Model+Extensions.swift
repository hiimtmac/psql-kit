//
//  File.swift
//  psql-kit
//
//  Created by Taylor McIntyre on 2024-11-05.
//

import PSQLKit
import FluentKit

extension CTE where Self: Schema {
    public static var schema: String { tableName }
    public static var space: String? { schemaName }
}
